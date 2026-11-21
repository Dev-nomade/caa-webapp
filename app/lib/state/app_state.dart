import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/tts_service.dart';
import '../data/cards.dart';

class UsoRegistro {
  final String cartaoId;
  final int timestamp;
  final int hora;
  UsoRegistro(this.cartaoId, this.timestamp, this.hora);

  Map<String, dynamic> toJson() => {'c': cartaoId, 't': timestamp, 'h': hora};
  factory UsoRegistro.fromJson(Map<String, dynamic> j) =>
      UsoRegistro(j['c'] as String, j['t'] as int, j['h'] as int);
}

class Sugestao {
  final String mensagem;
  final String cartaoId;
  const Sugestao(this.mensagem, this.cartaoId);
}

/// Estado do app. Tudo fica salvo só no aparelho (SharedPreferences).
class AppState extends ChangeNotifier {
  AppState(this.tts, this._prefs, {DateTime Function()? agora})
      : _agora = agora ?? DateTime.now {
    _carregar();
  }

  final TtsService tts;
  final SharedPreferences _prefs;
  final DateTime Function() _agora;

  final List<PecsCard> frase = [];
  List<UsoRegistro> historico = [];
  Set<String> ocultos = {};
  String pin = '1234';
  bool altoContraste = false;
  int colunas = 2;

  void _carregar() {
    try {
      final h = _prefs.getString('historico');
      if (h != null) {
        historico = (jsonDecode(h) as List)
            .map((e) => UsoRegistro.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      historico = [];
    }
    ocultos = (_prefs.getStringList('ocultos') ?? []).toSet();
    pin = _prefs.getString('pin') ?? '1234';
    altoContraste = _prefs.getBool('altoContraste') ?? false;
    colunas = _prefs.getInt('colunas') ?? 2;
  }

  List<PecsCard> get visiveis =>
      cartoes.where((c) => !ocultos.contains(c.id)).toList();

  // ---- Barra de frase ----
  void tocarCartao(PecsCard c) {
    frase.add(c);
    _registrar(c.id);
    tts.falar(c.frase);
    notifyListeners();
  }

  void falarFrase() {
    if (frase.isEmpty) return;
    tts.falar(frase.map((c) => c.rotulo.toLowerCase()).join(' '));
  }

  void removerUltimo() {
    if (frase.isNotEmpty) frase.removeLast();
    notifyListeners();
  }

  void limparFrase() {
    frase.clear();
    notifyListeners();
  }

  // ---- SOS ----
  void acionarSos(SosOption o) => tts.falar(o.frase);

  // ---- Cuidador ----
  void alternarCartao(String id) {
    ocultos.contains(id) ? ocultos.remove(id) : ocultos.add(id);
    _prefs.setStringList('ocultos', ocultos.toList());
    notifyListeners();
  }

  void definirColunas(int n) {
    colunas = n;
    _prefs.setInt('colunas', n);
    notifyListeners();
  }

  void definirAltoContraste(bool v) {
    altoContraste = v;
    _prefs.setBool('altoContraste', v);
    notifyListeners();
  }

  void definirPin(String novo) {
    pin = novo;
    _prefs.setString('pin', novo);
    notifyListeners();
  }

  void limparHistorico() {
    historico = [];
    _salvarHistorico();
    notifyListeners();
  }

  // ---- Histórico e sugestões (lógica local, sem IA remota) ----
  void _registrar(String id) {
    final n = _agora();
    historico.add(UsoRegistro(id, n.millisecondsSinceEpoch, n.hour));
    final limite = n.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    historico = historico.where((r) => r.timestamp > limite).toList();
    _salvarHistorico();
  }

  void _salvarHistorico() => _prefs.setString(
      'historico', jsonEncode(historico.map((e) => e.toJson()).toList()));

  /// Quantas vezes cada cartão foi usado nos últimos 7 dias.
  Map<String, int> get contagem {
    final m = <String, int>{};
    for (final r in historico) {
      m[r.cartaoId] = (m[r.cartaoId] ?? 0) + 1;
    }
    return m;
  }

  List<Sugestao> get sugestoes {
    final hora = _agora().hour;
    final out = <Sugestao>[];

    bool padrao(String id, int ini, int fim) =>
        hora >= ini &&
        hora <= fim &&
        historico.where((r) => r.cartaoId == id && r.hora >= ini && r.hora <= fim).length >= 2;

    if (padrao('comer', 6, 9)) out.add(const Sugestao('Hora do café da manhã?', 'comer'));
    if (padrao('comer', 11, 13)) out.add(const Sugestao('Hora do almoço?', 'comer'));
    if (padrao('comer', 14, 16)) out.add(const Sugestao('Hora do lanche?', 'comer'));
    if (padrao('comer', 18, 20)) out.add(const Sugestao('Hora do jantar?', 'comer'));
    if (hora >= 20 || hora < 5) out.add(const Sugestao('Já está tarde. Quer dormir?', 'dormir'));
    if (padrao('banho', 16, 19)) out.add(const Sugestao('Hora do banho?', 'banho'));
    return out;
  }
}
