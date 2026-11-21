import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../data/cards.dart';
import '../../state/app_state.dart';
import '../cuidador/caregiver_page.dart';
import '../rotina/rotina_page.dart';
import 'sos_sheet.dart';

/// Modo Criança: poucos elementos, botões grandes, sem texto longo.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final sugestoes = s.sugestoes;

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
                onPressed: () => mostrarSos(context),
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
      body: Column(
        children: [
          const _BarraFrase(),
          if (sugestoes.isNotEmpty)
            _Sugestoes(sugestoes: sugestoes),
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
              Text(card.emoji, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 8),
              Text(card.rotulo,
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarraFrase extends StatelessWidget {
  const _BarraFrase();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: s.frase.isEmpty
                  ? const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Toque nos cartões', style: TextStyle(color: Colors.black45, fontSize: 18)))
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final c in s.frase)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Center(child: Text(c.emoji, style: const TextStyle(fontSize: 36))),
                          )
                      ],
                    ),
            ),
          ),
          IconButton(
              tooltip: 'Apagar último',
              iconSize: 30,
              onPressed: s.removerUltimo,
              icon: const Icon(Icons.backspace_outlined)),
          IconButton(
              tooltip: 'Limpar frase',
              iconSize: 30,
              onPressed: s.limparFrase,
              icon: const Icon(Icons.delete_outline)),
          IconButton.filled(
              tooltip: 'Falar frase',
              iconSize: 32,
              onPressed: s.falarFrase,
              icon: const Icon(Icons.volume_up)),
        ],
      ),
    );
  }
}

class _Sugestoes extends StatelessWidget {
  const _Sugestoes({required this.sugestoes});
  final List<Sugestao> sugestoes;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final s0 = sugestoes.first;
    final card = cartoes.firstWhere((c) => c.id == s0.cartaoId);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: ActionChip(
        avatar: Text(card.emoji, style: const TextStyle(fontSize: 22)),
        label: Text(s0.mensagem, style: const TextStyle(fontSize: 18)),
        onPressed: () => s.tocarCartao(card),
      ),
    );
  }
}
