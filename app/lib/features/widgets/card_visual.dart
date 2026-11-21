import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';

import '../../data/cards.dart';

/// Mostra a foto do cartão (se houver) ou o emoji.
class CardVisual extends StatelessWidget {
  const CardVisual(this.card, {super.key, this.tamanho = 56});
  final PecsCard card;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    final emoji = Text(card.emoji, style: TextStyle(fontSize: tamanho));
    final foto = card.fotoPath;
    if (kIsWeb || foto == null) return emoji;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(foto),
        width: tamanho * 1.6,
        height: tamanho * 1.6,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => emoji,
      ),
    );
  }
}
