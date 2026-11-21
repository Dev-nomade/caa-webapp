import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

/// Cuidador monta a rotina: arrastar para reordenar, deslizar para remover.
class RotinaEditorPage extends StatelessWidget {
  const RotinaEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Editar rotina')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _escolher(context),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar passo'),
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.only(bottom: 96),
        itemCount: s.rotina.length,
        onReorderItem: s.moverPasso,
        itemBuilder: (_, i) {
          final c = s.passosRotina[i];
          return Dismissible(
            key: ValueKey('passo-$i-${c.id}'),
            background: Container(color: Colors.red.shade200),
            onDismissed: (_) => s.removerPasso(i),
            child: ListTile(
              key: ValueKey('tile-$i-${c.id}'),
              leading: Text(c.emoji, style: const TextStyle(fontSize: 32)),
              title: Text('${i + 1}. ${c.rotulo}'),
              subtitle: const Text(
                'Arraste para mudar a ordem • deslize para remover',
              ),
              trailing: ReorderableDragStartListener(
                index: i,
                child: const Icon(Icons.drag_handle),
              ),
            ),
          );
        },
      ),
    );
  }

  void _escolher(BuildContext context) {
    final s = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        children: [
          for (final c in s.todos)
            ListTile(
              leading: Text(c.emoji, style: const TextStyle(fontSize: 28)),
              title: Text(c.rotulo),
              onTap: () {
                s.adicionarPasso(c.id);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
