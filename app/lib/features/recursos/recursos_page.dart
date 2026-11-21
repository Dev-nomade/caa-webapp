import 'package:material_ui/material_ui.dart';

import '../../data/recursos.dart';
import '../../core/youtube.dart';

/// Botão "Vídeo": capas lado a lado, tudo junto. Tocar abre direto no YouTube.
class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) => _GradeVideos(
    titulo: 'Vídeo',
    videos: [for (final g in gruposVideos) ...g.itens],
  );
}

/// Botão "Música": mesmas capas (alfabeto musical e músicas para relaxar).
class MusicasPage extends StatelessWidget {
  const MusicasPage({super.key});

  @override
  Widget build(BuildContext context) => _GradeVideos(
    titulo: 'Música',
    videos: [
      ...musicasAlfabeto.itens,
      for (final m in musicasRelaxantes) VideoItem(m.titulo, m.videoId),
    ],
  );
}

class _GradeVideos extends StatelessWidget {
  const _GradeVideos({required this.titulo, required this.videos});
  final String titulo;
  final List<VideoItem> videos;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(titulo)),
    body: GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320, // mais colunas em telas largas
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: videos.length,
      itemBuilder: (_, i) => _CapaVideo(videos[i]),
    ),
  );
}

class _CapaVideo extends StatelessWidget {
  const _CapaVideo(this.video);
  final VideoItem video;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Assistir ${video.titulo} no YouTube',
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => abrirNoYoutube(video.videoId),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://i.ytimg.com/vi/${video.videoId}/hqdefault.jpg',
                      fit: BoxFit.cover,
                      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: Color(0xFFBBD8F5),
                        child: Center(
                          child: Text('🎬', style: TextStyle(fontSize: 48)),
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 56,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  video.titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dicas para o cuidador (aberta pela área do cuidador).
class DicasPage extends StatelessWidget {
  const DicasPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dicas para o cuidador')),
    body: ListView(
      padding: const EdgeInsets.all(12),
      children: [
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
  );
}
