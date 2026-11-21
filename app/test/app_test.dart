import 'package:material_ui/material_ui.dart' show Switch;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cognitia/core/media_service.dart';
import 'package:cognitia/core/sound_service.dart';
import 'package:cognitia/core/tts_service.dart';
import 'package:cognitia/data/cards.dart';
import 'package:cognitia/data/recursos.dart';
import 'package:cognitia/main.dart';
import 'package:cognitia/state/app_state.dart';

class FakeMedia extends MediaService {
  final tocados = <String>[];
  final apagados = <String?>[];
  @override
  Future<void> tocar(String caminho) async => tocados.add(caminho);
  @override
  Future<void> apagar(String? caminho) async => apagados.add(caminho);
}

class FakeSons extends SoundService {
  int alertas = 0;
  @override
  Future<void> tocarAlerta() async => alertas++;
}

class FakeTts extends TtsService {
  final falas = <String>[];
  @override
  Future<void> falar(String texto) async => falas.add(texto);
}

void main() {
  group("rotina", rotinaTests);
  group("videos", videosTests);
  group("personalizados", personalizadosTests);
  late FakeTts tts;
  late AppState estado;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tts = FakeTts();
    estado = AppState(
      tts,
      await SharedPreferences.getInstance(),
      agora: () => DateTime(2026, 1, 1, 12),
    );
  });

  test('tocar cartão fala a frase e entra na barra', () {
    estado.tocarCartao(cartoes.first);
    expect(tts.falas, ['Comer']);
    expect(estado.frase.length, 1);
  });

  test('frase com vários cartões é falada junta', () {
    estado.tocarCartao(cartoes[0]);
    estado.tocarCartao(cartoes[1]);
    estado.falarFrase();
    expect(tts.falas.last, 'comer beber');
  });

  test('modo escuro é salvo no aparelho', () async {
    expect(estado.escuro, false);
    estado.definirEscuro(true);
    final prefs = await SharedPreferences.getInstance();
    final outro = AppState(tts, prefs);
    expect(outro.escuro, true);
  });

  test('botão SOS fala "Me ajude" e toca o alerta suave', () async {
    final sons = FakeSons();
    final s = AppState(tts, await SharedPreferences.getInstance(), sons: sons);
    s.pedirAjuda();
    expect(tts.falas.last, 'Me ajude');
    expect(sons.alertas, 1);
  });

  test('alerta gera um arquivo WAV válido', () {
    final b = SoundService.gerarAlerta();
    expect(String.fromCharCodes(b.sublist(0, 4)), 'RIFF');
    expect(String.fromCharCodes(b.sublist(8, 12)), 'WAVE');
    expect(b.length, greaterThan(1000));
  });

  test('vídeo ao tocar fica desligado por padrão e pode ser ligado', () {
    expect(estado.videoAoTocar, false);
    estado.definirVideoAoTocar(true);
    expect(estado.videoAoTocar, true);
    expect(cartoes.every((c) => c.videoId != null), true);
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
    expect(find.text('Vídeo'), findsOneWidget);
    expect(find.text('Música'), findsOneWidget);
    expect(find.text('Modo claro'), findsOneWidget);
    await t.tap(find.byType(Switch));
    await t.pump();
    expect(find.text('Modo escuro'), findsOneWidget);
  });
}

void rotinaTests() {
  late FakeTts tts;
  late AppState estado;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tts = FakeTts();
    estado = AppState(
      tts,
      await SharedPreferences.getInstance(),
      agora: () => DateTime(2026, 1, 1, 8),
    );
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

void personalizadosTests() {
  late FakeTts tts;
  late FakeMedia media;
  late SharedPreferences prefs;
  AppState novo() =>
      AppState(tts, prefs, agora: () => DateTime(2026, 1, 1, 8), media: media);
  const vovo = PecsCard(
    'c_1',
    'Vovó',
    'Quero ver a vovó',
    '👵',
    CardCategory.acoes,
    fotoPath: '/x/foto.jpg',
    audioPath: '/x/voz.m4a',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    tts = FakeTts();
    media = FakeMedia();
  });

  test('cartão com voz gravada toca o áudio em vez da voz do celular', () {
    final s = novo()..adicionarPersonalizado(vovo);
    s.tocarCartao(vovo);
    expect(media.tocados, ['/x/voz.m4a']);
    expect(tts.falas, isEmpty);
  });

  test('cartão sem áudio usa a voz do celular', () {
    final s = novo();
    const sem = PecsCard(
      'c_2',
      'Bola',
      'Quero a bola',
      '⚽',
      CardCategory.acoes,
    );
    s.adicionarPersonalizado(sem);
    s.tocarCartao(sem);
    expect(tts.falas, ['Bola']);
  });

  test('cartões personalizados persistem e aparecem na lista', () {
    novo().adicionarPersonalizado(vovo);
    final s2 = novo();
    expect(s2.personalizados.single.rotulo, 'Vovó');
    expect(s2.visiveis.any((c) => c.id == 'c_1'), true);
  });

  test('apagar remove arquivos, rotina e visibilidade', () {
    final s = novo()..adicionarPersonalizado(vovo);
    s.adicionarPasso('c_1');
    s.removerPersonalizado('c_1');
    expect(media.apagados, containsAll(['/x/foto.jpg', '/x/voz.m4a']));
    expect(s.rotina.contains('c_1'), false);
    expect(s.buscar('c_1'), null);
  });

  test('cartões fixos não podem ser apagados', () {
    final s = novo()..removerPersonalizado('comer');
    expect(s.buscar('comer'), isNotNull);
  });
}

void videosTests() {
  final todos = [
    for (final g in [
      ...gruposVideos,
      musicasAlfabeto,
      musicasGalinhaPintadinha,
      musicasPalavraCantada,
    ])
      ...g.itens.map((v) => v.videoId),
  ];

  test('vídeos: códigos têm 11 caracteres e não se repetem', () {
    for (final id in todos) {
      expect(id.length, 11, reason: id);
    }
    for (final g in gruposVideos) {
      final ids = g.itens.map((v) => v.videoId).toList();
      expect(ids.toSet().length, ids.length, reason: g.nome);
    }
  });

  test('há grupos de Peppa, Masha, Pooh e alfabeto musical', () {
    final nomes = gruposVideos.map((g) => g.nome).toList();
    expect(nomes, containsAll(['Peppa Pig', 'Masha e o Urso', 'Ursinho Pooh']));
    expect(musicasAlfabeto.itens, isNotEmpty);
    expect(musicasGalinhaPintadinha.itens, isNotEmpty);
    expect(musicasPalavraCantada.itens, isNotEmpty);
  });
}
