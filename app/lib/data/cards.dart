import 'package:material_ui/material_ui.dart';

enum CardCategory { necessidades, sentimentos, acoes }

extension CardCategoryX on CardCategory {
  String get nome => switch (this) {
    CardCategory.necessidades => 'Necessidades',
    CardCategory.sentimentos => 'Sentimentos',
    CardCategory.acoes => 'Ações',
  };

  Color get cor => switch (this) {
    CardCategory.necessidades => const Color(0xFFBFE3C0),
    CardCategory.sentimentos => const Color(0xFFFFF0B3),
    CardCategory.acoes => const Color(0xFFBBD8F5),
  };
}

class PecsCard {
  final String id;
  final String rotulo;
  final String frase; // o que será falado
  final String emoji;
  final CardCategory categoria;
  final String? fotoPath; // foto do cartão personalizado
  final String? audioPath; // voz gravada pelo familiar
  final String? videoId; // vídeo do YouTube mostrado ao tocar (opcional)

  const PecsCard(
    this.id,
    this.rotulo,
    this.frase,
    this.emoji,
    this.categoria, {
    this.fotoPath,
    this.audioPath,
    this.videoId,
  });

  bool get personalizado => id.startsWith('c_');

  Map<String, dynamic> toJson() => {
    'id': id,
    'rotulo': rotulo,
    'frase': frase,
    'emoji': emoji,
    'categoria': categoria.name,
    'foto': fotoPath,
    'audio': audioPath,
  };

  factory PecsCard.fromJson(Map<String, dynamic> j) => PecsCard(
    j['id'] as String,
    j['rotulo'] as String,
    j['frase'] as String,
    j['emoji'] as String,
    CardCategory.values.byName(j['categoria'] as String),
    fotoPath: j['foto'] as String?,
    audioPath: j['audio'] as String?,
  );
}

const cartoes = <PecsCard>[
  PecsCard(
    'comer',
    'Comer',
    'Eu quero comer',
    '🍽️',
    CardCategory.necessidades,
    videoId: 'KY-VXRqm2Pg',
  ),
  PecsCard(
    'beber',
    'Beber',
    'Eu quero beber',
    '🥤',
    CardCategory.necessidades,
    videoId: '6upE2O4QINY',
  ),
  PecsCard(
    'banho',
    'Banho',
    'Eu quero tomar banho',
    '🚿',
    CardCategory.necessidades,
    videoId: 'aueefWtXdpM',
  ),
  PecsCard(
    'dormir',
    'Dormir',
    'Eu quero dormir',
    '😴',
    CardCategory.necessidades,
    videoId: '7xaCG3LbSCw',
  ),
  PecsCard(
    'banheiro',
    'Banheiro',
    'Eu preciso ir ao banheiro',
    '🚽',
    CardCategory.necessidades,
    videoId: 'aueefWtXdpM',
  ),
  PecsCard(
    'feliz',
    'Feliz',
    'Eu estou feliz',
    '😊',
    CardCategory.sentimentos,
    videoId: 'SLYx0Kv37Hs',
  ),
  PecsCard(
    'triste',
    'Triste',
    'Eu estou triste',
    '😢',
    CardCategory.sentimentos,
    videoId: '9l3jNTZ_qgU',
  ),
  PecsCard(
    'cansado',
    'Cansado',
    'Eu estou cansado',
    '😩',
    CardCategory.sentimentos,
    videoId: 'Z3MorRFqJWc',
  ),
  PecsCard(
    'fome',
    'Fome',
    'Eu estou com fome',
    '🤤',
    CardCategory.sentimentos,
    videoId: 'G_p8uFBgxhM',
  ),
  PecsCard(
    'sede',
    'Sede',
    'Eu estou com sede',
    '💧',
    CardCategory.sentimentos,
    videoId: 'VWXu9H6WVk0',
  ),
  PecsCard(
    'ansioso',
    'Ansioso',
    'Eu estou ansioso',
    '😰',
    CardCategory.sentimentos,
    videoId: 'hlWiI4xVXKY',
  ),
  PecsCard(
    'calmo',
    'Calmo',
    'Eu estou calmo',
    '😌',
    CardCategory.sentimentos,
    videoId: 'rYoZgpAEkFs',
  ),
  PecsCard(
    'vestir',
    'Vestir',
    'Eu quero me vestir',
    '👕',
    CardCategory.acoes,
    videoId: 'gSEu2od18PQ',
  ),
  PecsCard(
    'passear',
    'Passear',
    'Eu quero passear',
    '🚶',
    CardCategory.acoes,
    videoId: 'rYoZgpAEkFs',
  ),
  PecsCard(
    'brincar',
    'Brincar',
    'Eu quero brincar',
    '🎮',
    CardCategory.acoes,
    videoId: 'gSEu2od18PQ',
  ),
  PecsCard(
    'estudar',
    'Estudar',
    'Eu quero estudar',
    '📚',
    CardCategory.acoes,
    videoId: 'QkddAGUgASE',
  ),
  PecsCard(
    'musica',
    'Música',
    'Eu quero ouvir música',
    '🎵',
    CardCategory.acoes,
    videoId: '77ZozI0rw7w',
  ),
  PecsCard(
    'abraco',
    'Abraço',
    'Eu quero um abraço',
    '🤗',
    CardCategory.acoes,
    videoId: 'gSEu2od18PQ',
  ),
];
