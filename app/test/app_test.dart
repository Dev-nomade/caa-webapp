import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cognitia/core/tts_service.dart';
import 'package:cognitia/data/cards.dart';
import 'package:cognitia/main.dart';
import 'package:cognitia/state/app_state.dart';

class FakeTts extends TtsService {
  final falas = <String>[];
  @override
  Future<void> falar(String texto) async => falas.add(texto);
}

void main() {
  group("rotina", rotinaTests);
  late FakeTts tts;
  late AppState estado;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tts = FakeTts();
    estado = AppState(tts, await SharedPreferences.getInstance(),
        agora: () => DateTime(2026, 1, 1, 12));
  });

  test('tocar cartão fala a frase e entra na barra', () {
    estado.tocarCartao(cartoes.first);
    expect(tts.falas, ['Eu quero comer']);
    expect(estado.frase.length, 1);
  });

  test('frase com vários cartões é falada junta', () {
    estado.tocarCartao(cartoes[0]);
    estado.tocarCartao(cartoes[1]);
    estado.falarFrase();
    expect(tts.falas.last, 'comer beber');
  });

  test('SOS fala a mensagem', () {
    estado.acionarSos(opcoesSos.first);
    expect(tts.falas.last, 'Estou com dor');
  });

  test('ocultar cartão remove da lista visível', () {
    estado.alternarCartao('comer');
    expect(estado.visiveis.any((c) => c.id == 'comer'), false);
  });

  test('sugestão de almoço após 2 usos na janela', () {
    estado.tocarCartao(cartoes.first);
    estado.tocarCartao(cartoes.first);
    expect(estado.sugestoes.first.mensagem, contains('almoço'));
  });

  testWidgets('app abre e mostra cartões', (t) async {
    await t.pumpWidget(CognitiaApp(estado: estado));
    expect(find.text('Comer'), findsOneWidget);
    expect(find.text('SOS'), findsOneWidget);
  });
}

void rotinaTests() {
  late FakeTts tts;
  late AppState estado;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tts = FakeTts();
    estado = AppState(tts, await SharedPreferences.getInstance(),
        agora: () => DateTime(2026, 1, 1, 8));
  });

  test('rotina: passo atual avança ao concluir', () {
    expect(estado.passoAtual, 0);
    estado.concluirPasso(0);
    expect(estado.passoAtual, 1);
    expect(tts.falas.last, contains('Muito bem'));
  });

  test('rotina: concluir tudo retorna -1 e reiniciar zera', () {
    for (var i = 0; i < estado.rotina.length; i++) {
      estado.concluirPasso(i);
    }
    expect(estado.passoAtual, -1);
    estado.reiniciarRotina();
    expect(estado.passoAtual, 0);
  });

  test('rotina: adicionar, mover e remover passos', () {
    final n = estado.rotina.length;
    estado.adicionarPasso('musica');
    expect(estado.rotina.length, n + 1);
    estado.moverPasso(n, 0);
    expect(estado.rotina.first, 'musica');
    estado.removerPasso(0);
    expect(estado.rotina.length, n);
  });

  test('rotina: progresso zera em novo dia', () async {
    estado.concluirPasso(0);
    final prefs = await SharedPreferences.getInstance();
    final amanha = AppState(tts, prefs, agora: () => DateTime(2026, 1, 2, 8));
    expect(amanha.passoAtual, 0);
    final mesmoDia = AppState(tts, prefs, agora: () => DateTime(2026, 1, 1, 9));
    expect(mesmoDia.passoAtual, 1);
  });
}
