class Dica {
  final String titulo, texto;
  const Dica(this.titulo, this.texto);
}

class Musica {
  final String titulo, artista, videoId;
  const Musica(this.titulo, this.artista, this.videoId);
}

const dicasCuidador = <Dica>[
  Dica(
    'Rotina consistente',
    'Mantenha uma rotina diária previsível. Pessoas no espectro autista se beneficiam de saber o que esperar ao longo do dia. Use apoios visuais, como calendários e quadros de rotina.',
  ),
  Dica(
    'Ambiente sensorial',
    'Reduza estímulos sensoriais em excesso. Mantenha luzes suaves, diminua o barulho e ofereça espaços calmos. Observe quais estímulos mais incomodam a pessoa.',
  ),
  Dica(
    'Comunicação visual',
    'Use apoios visuais (PECS, imagens, símbolos) para complementar a comunicação verbal. Dê tempo para a pessoa processar a informação antes de repetir ou reformular.',
  ),
  Dica(
    'Transições tranquilas',
    'Avise com antecedência sobre mudanças de atividade. Use temporizadores visuais e contagem regressiva para ajudar na troca entre atividades.',
  ),
  Dica(
    'Reforço positivo',
    'Comemore conquistas e comportamentos positivos. Use elogios específicos e concretos. Evite frases vagas como "muito bem" — prefira "Você guardou seus brinquedos, parabéns!".',
  ),
  Dica(
    'Sinais de sobrecarga',
    'Aprenda a identificar sinais de sobrecarga sensorial: tapar os ouvidos, balançar o corpo, evitar o olhar. Ofereça um espaço calmo quando notar esses sinais.',
  ),
  Dica(
    'Alimentação',
    'Respeite as preferências alimentares e apresente alimentos novos aos poucos. Muitas pessoas autistas têm sensibilidade a texturas e sabores.',
  ),
  Dica(
    'Hora de dormir',
    'Crie uma rotina de sono relaxante e constante. Reduza estímulos visuais e sonoros antes de dormir. Considere luzes noturnas suaves e cobertores pesados.',
  ),
];

const musicasRelaxantes = <Musica>[
  Musica('Música relaxante para crianças', 'Sons da natureza', 'hlWiI4xVXKY'),
  Musica('Canções calmas para crianças', 'Canções de ninar', '77ZozI0rw7w'),
  Musica('Sons da natureza - Pássaros', 'Natureza', 'rYoZgpAEkFs'),
  Musica('Música clássica para relaxar', 'Clássicos', 'HMnrl0tmd3k'),
];

/// Um vídeo do YouTube. Para trocar ou acrescentar vídeos, edite as listas abaixo:
/// o código é o que vem depois de "watch?v=" no endereço do vídeo.
class VideoItem {
  final String titulo, videoId;
  const VideoItem(this.titulo, this.videoId);
}

/// Um grupo de vídeos (ex.: Peppa Pig) com um atalho de busca no YouTube.
class GrupoVideos {
  final String nome, emoji, busca;
  final List<VideoItem> itens;
  const GrupoVideos(this.nome, this.emoji, this.busca, this.itens);
}

const gruposVideos = <GrupoVideos>[
  GrupoVideos(
    'Peppa Pig',
    '🐷',
    'Peppa Pig Português Brasil episódios completos',
    [
      VideoItem('Papai Pig perde suas chaves', 'VUn5t1iqR-4'),
      VideoItem('Aventura no aeroporto', 'w9I7eV8iCn0'),
      VideoItem('Um dia no parque aquático', 'DjIUsJylBAM'),
      VideoItem('Vários episódios completos 1', 'HK6s92pGrbI'),
      VideoItem('Vários episódios completos 2', 'LDNRGdPVwrg'),
    ],
  ),
  GrupoVideos(
    'Masha e o Urso',
    '🐻',
    'Masha e o Urso episódio completo português',
    [
      VideoItem('O poder do banho', 'ZOozD8UGC7Y'),
      VideoItem('Coração de ouro', 'mUmJ2nxKIuY'),
      VideoItem('Estação chuvosa', '2r4vBwV7Xd0'),
      VideoItem('Crianças imprevisíveis', 'DGMJ8SBw1a0'),
      VideoItem('Todos os episódios dos curtas', 'TewZ-NzfMmw'),
    ],
  ),
  GrupoVideos('Ursinho Pooh', '🍯', 'Ursinho Pooh desenho em português', [
    VideoItem('Ursinho Pooh completo em português', 'AcUSbT9ENoA'),
    VideoItem('Ursinho Pooh Disney', 'cJhR303VDeg'),
  ]),
];

const musicasAlfabeto = GrupoVideos(
  'Alfabeto musical',
  '🔤',
  'alfabeto musical ABC música infantil português',
  [
    VideoItem('LiaChaCha - ABC, música do alfabeto', 'dNpNqLbm6tM'),
    VideoItem('ABC em português - aprenda o alfabeto cantando', 'THmAfClxHX0'),
    VideoItem('Canção do ABC', 'DOI_mvdXcms'),
    VideoItem('Música do ABC', 'kNAYhwuAC4A'),
    VideoItem('ABC música - as letras do alfabeto cantadas', '2rveknq8LWI'),
    VideoItem('Música ABC em português', '-ZBND7ZwAuU'),
    VideoItem('Alfabeto em português', 'uQRWjl_AJyU'),
  ],
);
