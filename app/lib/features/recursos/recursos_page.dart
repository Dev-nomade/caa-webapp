import 'package:material_ui/material_ui.dart';

import '../../data/recursos.dart';
import '../widgets/video_dialog.dart';

/// Músicas relaxantes e dicas para o cuidador.
class RecursosPage extends StatelessWidget {
  const RecursosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recursos'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.music_note), text: 'Músicas'),
              Tab(icon: Icon(Icons.lightbulb_outline), text: 'Dicas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Músicas para acalmar. Precisam de internet para tocar.',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                for (final m in musicasRelaxantes)
                  Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const Icon(Icons.play_circle_fill, size: 44),
                      title: Text(
                        m.titulo,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(m.artista),
                      onTap: () =>
                          mostrarVideo(context, m.videoId, titulo: m.titulo),
                    ),
                  ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Dicas para o cuidador',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                for (final d in dicasCuidador)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.titulo,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            d.texto,
                            style: const TextStyle(fontSize: 17, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
