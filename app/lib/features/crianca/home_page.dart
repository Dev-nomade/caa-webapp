import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../data/cards.dart';
import '../../state/app_state.dart';
import '../cuidador/caregiver_page.dart';
import '../widgets/card_visual.dart';
import '../rotina/rotina_page.dart';
import 'sos_sheet.dart';

/// Modo Criança: poucos elementos, botões grandes, sem texto longo.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('CognitIA'),
        actions: [
          Semantics(
            label: 'Botão de ajuda SOS',
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD9534F)),
                onPressed: () {
                  context.read<AppState>().pedirAjuda();
                  mostrarSos(context);
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
                context, MaterialPageRoute(builder: (_) => const RotinaPage())),
          ),
          IconButton(
            tooltip: 'Área do cuidador',
            iconSize: 32,
            icon: const Icon(Icons.lock_outline),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CaregiverGate())),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SwitchListTile(
          dense: true,
          secondary: Icon(s.escuro ? Icons.dark_mode : Icons.light_mode),
          title: Text(s.escuro ? 'Modo escuro' : 'Modo claro'),
          value: s.escuro,
          onChanged: s.definirEscuro,
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
          onTap: () => context.read<AppState>().tocarCartao(card),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardVisual(card, tamanho: 56),
              const SizedBox(height: 8),
              Text(card.rotulo,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
