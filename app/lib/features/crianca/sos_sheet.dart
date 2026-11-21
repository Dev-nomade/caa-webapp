import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/cards.dart';
import '../../state/app_state.dart';

void mostrarSos(BuildContext context) {
  HapticFeedback.mediumImpact(); // vibração suave
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFF1F0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Preciso de ajuda',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            for (final o in opcoesSos)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE57373),
                    ),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      context.read<AppState>().acionarSos(o);
                    },
                    child: Text(
                      '${o.emoji}  ${o.rotulo}',
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
