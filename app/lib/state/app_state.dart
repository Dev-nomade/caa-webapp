import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/media_service.dart';
import '../core/sound_service.dart';
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
  AppState(
    this.tts,
    this._prefs, {
    DateTime Function()? agora,
    MediaService? media,
    SoundService? sons,
  }) : _agora = agora ?? DateTime.now,
       media = media ?? MediaService(),
       sons = sons ?? SoundService() {
    _carregar();
  }

  final TtsService tts;
  final MediaService media;
  final SoundService sons;
  final SharedPreferences _prefs;
  final DateTime Function() _agora;

  final List<PecsCard> frase = [];
  List<UsoRegistro> historico = [];
  Set<String> ocultos = {};
  String pin = '1234';
  bool altoContraste = false;
  bool escuro = false;
  bool videoAoTocar = true;
  int colunas = 2;

  // ---- Rotina visual ----
  static const rotinaPadrao = [
    'vestir',
    'comer',
    'estudar',
    'brincar',
    'banho',
    'comer',
    'dormir',
  ];
  List<String> rotina = List.of(rotinaPadrao);
  Set<int> feitos = {};
  List<PecsCard> personalizados = [];
  String _dataFeitos = '';

  String get _hoje {
    final d = _agora();
    return '${d.year}-${d.month}-${d.day}';
  }

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
    try {
      personalizados = (_prefs.getStringList('personalizados') ?? [])
          .map((e) => PecsCard.fromJson(jsonDecode(e) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      personalizados = [];
    }
    ocultos = (_prefs.getStringList('ocultos') ?? []).toSet();
    pin = _prefs.getString('pin') ?? '1234';
    altoContraste = _prefs.getBool('altoContraste') ?? false;
    escuro = _prefs.getBool('escuro') ?? false;
    videoAoTocar = _prefs.getBool('videoAoTocar') ?? true;
    colunas = _prefs.getInt('colunas') ?? 2;
    rotina = (_prefs.getStringList('rotina') ?? List.of(rotinaPadrao))
        .where((id) => buscar(id) != null)
        .toList();
    _dataFeitos = _prefs.getString('rotinaData') ?? '';
    if (_dataFeitos == _hoje) {
      feitos = (_prefs.getStringList('rotinaFeitos') ?? [])
          .map(int.parse)
          .toSet();
    } else {
      feitos = {}; // novo dia: a rotina recomeça
    }
  }

  /// Cartões fixos + cartões criados pela família.
  List<PecsCard> get todos => [...cartoes, ...personalizados];

  PecsCard? buscar(String id) {
    for (final c in todos) {
      if (c.id == id) return c;
    }
    return null;
  }

  PecsCard _card(String id) => buscar(id)!;

  // ---- Cartões personalizados ----
  void adicionarPersonalizado(PecsCard c) {
    personalizados.add(c);
    _salvarPersonalizados();
    notifyListeners();
  }

  void removerPersonalizado(String id) {
    final c = buscar(id);
    if (c == null || !c.personalizado) return;
    media.apagar(c.fotoPath);
    media.apagar(c.audioPath);
    personalizados.removeWhere((x) => x.id == id);
    ocultos.remove(id);
    if (rotina.contains(id)) {
      rotina.removeWhere((x) => x == id);
      feitos = {};
      _salvarRotina();
      _salvarFeitos();
    }
    frase.removeWhere((x) => x.id == id);
    _prefs.setStringList('ocultos', ocultos.toList());
    _salvarPersonalizados();
    notifyListeners();
  }

  void _salvarPersonalizados() => _prefs.setStringList(
    'personalizados',
    personalizados.map((c) => jsonEncode(c.toJson())).toList(),
  );

  /// Fala só a palavra do cartão (ex.: "Comer"); usa a voz gravada pela família, se existir.
  void _dizer(PecsCard c) {
    if (c.audioPath != null) {
      media.tocar(c.audioPath!);
    } else {
      tts.falar(c.rotulo);
    }
  }

  List<PecsCard> get passosRotina => rotina.map(_card).toList();

  /// Índice do primeiro passo ainda não feito (ou -1 se tudo concluído).
  int get passoAtual {
    for (var i = 0; i < rotina.length; i++) {
      if (!feitos.contains(i)) return i;
    }
    return -1;
  }

  void concluirPasso(int i) {
    if (i < 0 || i >= rotina.length) return;
    feitos.contains(i) ? feitos.remove(i) : feitos.add(i);
    if (feitos.contains(i)) {
      tts.falar('${_card(rotina[i]).rotulo} feito. Muito bem!');
    }
    _salvarFeitos();
    notifyListeners();
  }

  void falarPasso(int i) => _dizer(_card(rotina[i]));

  void reiniciarRotina() {
    feitos = {};
    _salvarFeitos();
    notifyListeners();
  }

  void adicionarPasso(String id) {
    rotina.add(id);
    _salvarRotina();
    notifyListeners();
  }

  void removerPasso(int i) {
    rotina.removeAt(i);
    feitos = {}; // índices mudaram
    _salvarRotina();
    _salvarFeitos();
    notifyListeners();
  }

  void moverPasso(int de, int para) {
    final item = rotina.removeAt(de);
    rotina.insert(para, item);
    feitos = {};
    _salvarRotina();
    _salvarFeitos();
    notifyListeners();
  }

  void _salvarRotina() => _prefs.setStringList('rotina', rotina);

  void _salvarFeitos() {
    _dataFeitos = _hoje;
    _prefs.setString('rotinaData', _dataFeitos);
    _prefs.setStringList('rotinaFeitos', feitos.map((e) => '$e').toList());
  }

  List<PecsCard> get visiveis =>
      todos.where((c) => !ocultos.contains(c.id)).toList();

  /// Ouvir o cartão sem colocá-lo na frase nem no histórico (prévia do cuidador).
  void tocarCartaoSemFrase(PecsCard c) => _dizer(c);

  // ---- Barra de frase ----
  void tocarCartao(PecsCard c) {
    frase.add(c);
    _registrar(c.id);
    _dizer(c);
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
  /// Toque no botão SOS: pede ajuda em voz alta.
  void pedirAjuda() => tts.falar('Me ajude');

  void acionarSos(SosOption o) {
    tts.falar(o.frase);
    sons.tocarAlerta(); // alerta suave de três tons
  }

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

  void definirEscuro(bool v) {
    escuro = v;
    _prefs.setBool('escuro', v);
    notifyListeners();
  }

  void definirVideoAoTocar(bool v) {
    videoAoTocar = v;
    _prefs.setBool('videoAoTocar', v);
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
    'historico',
    jsonEncode(historico.map((e) => e.toJson()).toList()),
  );

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
        historico
                .where(
                  (r) => r.cartaoId == id && r.hora >= ini && r.hora <= fim,
                )
                .length >=
            2;

    if (padrao('comer', 6, 9)) {
      out.add(const Sugestao('Hora do café da manhã?', 'comer'));
    }
    if (padrao('comer', 11, 13)) {
      out.add(const Sugestao('Hora do almoço?', 'comer'));
    }
    if (padrao('comer', 14, 16)) {
      out.add(const Sugestao('Hora do lanche?', 'comer'));
    }
    if (padrao('comer', 18, 20)) {
      out.add(const Sugestao('Hora do jantar?', 'comer'));
    }
    if (hora >= 20 || hora < 5) {
      out.add(const Sugestao('Já está tarde. Quer dormir?', 'dormir'));
    }
    if (padrao('banho', 16, 19)) {
      out.add(const Sugestao('Hora do banho?', 'banho'));
    }
    return out;
  }
}
