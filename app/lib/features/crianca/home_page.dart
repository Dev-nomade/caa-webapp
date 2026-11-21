import 'package:flutter/services.dart' show HapticFeedback;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/cards.dart';
import '../../state/app_state.dart';
import '../cuidador/caregiver_page.dart';
import '../widgets/card_visual.dart';
import '../widgets/video_dialog.dart';
import '../recursos/recursos_page.dart';
import '../rotina/rotina_page.dart';

/// Modo Criança: poucos elementos, botões grandes, sem texto longo.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
            ),
          ),
        ),
        titleSpacing: 12,
        title: Semantics(
          label: 'CognitIA',
          child: const Row(
            children: [
              ExcludeSemantics(
                child: Text('🧠', style: TextStyle(fontSize: 30)),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'CognitIA',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Semantics(
            label: 'Botão de ajuda SOS',
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD9534F),
                ),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  context.read<AppState>().pedirAjuda();
                },
                icon: const Icon(Icons.sos),
                label: const Text('SOS'),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Minha rotina',
            iconSize: 32,
            icon: const Icon(Icons.checklist_rtl),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RotinaPage()),
            ),
          ),
          IconButton(
            tooltip: 'Área do cuidador',
            iconSize: 32,
            icon: const Icon(Icons.lock_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CaregiverGate()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.library_music_outlined),
              title: const Text('Recursos: músicas e dicas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecursosPage()),
              ),
            ),
            SwitchListTile(
              dense: true,
              secondary: Icon(s.escuro ? Icons.dark_mode : Icons.light_mode),
              title: Text(s.escuro ? 'Modo escuro' : 'Modo claro'),
              value: s.escuro,
              onChanged: s.definirEscuro,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(12),
              crossAxisCount: s.colunas,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [for (final c in s.visiveis) _CartaoTile(card: c)],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoTile extends StatelessWidget {
  const _CartaoTile({required this.card});
  final PecsCard card;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: card.rotulo,
      child: Material(
        color: card.categoria.cor,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            final s = context.read<AppState>();
            s.tocarCartao(card);
            if (s.videoAoTocar && card.videoId != null) {
              mostrarVideo(context, card.videoId!, titulo: card.rotulo);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardVisual(card, tamanho: 56),
              const SizedBox(height: 8),
              Text(
                card.rotulo,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
