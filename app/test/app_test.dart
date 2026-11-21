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
