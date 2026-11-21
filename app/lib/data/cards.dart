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

  const PecsCard(this.id, this.rotulo, this.frase, this.emoji, this.categoria);
}

const cartoes = <PecsCard>[
  PecsCard('comer', 'Comer', 'Eu quero comer', '🍽️', CardCategory.necessidades),
  PecsCard('beber', 'Beber', 'Eu quero beber', '🥤', CardCategory.necessidades),
  PecsCard('banho', 'Banho', 'Eu quero tomar banho', '🚿', CardCategory.necessidades),
  PecsCard('dormir', 'Dormir', 'Eu quero dormir', '😴', CardCategory.necessidades),
  PecsCard('banheiro', 'Banheiro', 'Eu preciso ir ao banheiro', '🚽', CardCategory.necessidades),
  PecsCard('feliz', 'Feliz', 'Eu estou feliz', '😊', CardCategory.sentimentos),
  PecsCard('triste', 'Triste', 'Eu estou triste', '😢', CardCategory.sentimentos),
  PecsCard('cansado', 'Cansado', 'Eu estou cansado', '😩', CardCategory.sentimentos),
  PecsCard('fome', 'Fome', 'Eu estou com fome', '🤤', CardCategory.sentimentos),
  PecsCard('sede', 'Sede', 'Eu estou com sede', '💧', CardCategory.sentimentos),
  PecsCard('ansioso', 'Ansioso', 'Eu estou ansioso', '😰', CardCategory.sentimentos),
  PecsCard('calmo', 'Calmo', 'Eu estou calmo', '😌', CardCategory.sentimentos),
  PecsCard('vestir', 'Vestir', 'Eu quero me vestir', '👕', CardCategory.acoes),
  PecsCard('passear', 'Passear', 'Eu quero passear', '🚶', CardCategory.acoes),
  PecsCard('brincar', 'Brincar', 'Eu quero brincar', '🎮', CardCategory.acoes),
  PecsCard('estudar', 'Estudar', 'Eu quero estudar', '📚', CardCategory.acoes),
  PecsCard('musica', 'Música', 'Eu quero ouvir música', '🎵', CardCategory.acoes),
  PecsCard('abraco', 'Abraço', 'Eu quero um abraço', '🤗', CardCategory.acoes),
];

class SosOption {
  final String id, rotulo, frase, emoji;
  const SosOption(this.id, this.rotulo, this.frase, this.emoji);
}

const opcoesSos = <SosOption>[
  SosOption('dor', 'Dor', 'Estou com dor', '🤕'),
  SosOption('barulho', 'Barulho alto', 'O barulho está muito alto', '🔊'),
  SosOption('medo', 'Medo', 'Estou com medo', '😨'),
];
