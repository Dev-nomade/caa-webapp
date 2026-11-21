import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Abre um vídeo do YouTube em uma janela (precisa de internet).
Future<void> mostrarVideo(
  BuildContext context,
  String videoId, {
  String? titulo,
}) {
  return showDialog(
    context: context,
    builder: (_) => _VideoDialog(videoId: videoId, titulo: titulo),
  );
}

class _VideoDialog extends StatefulWidget {
  const _VideoDialog({required this.videoId, this.titulo});
  final String videoId;
  final String? titulo;
  @override
  State<_VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<_VideoDialog> {
  late final YoutubePlayerController _c = YoutubePlayerController.fromVideoId(
    videoId: widget.videoId,
    autoPlay: true,
    params: const YoutubePlayerParams(showFullscreenButton: true),
  );

  @override
  void dispose() {
    _c.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.titulo ?? 'Vídeo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton.filled(
                  tooltip: 'Fechar vídeo',
                  iconSize: 32,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: YoutubePlayer(controller: _c, aspectRatio: 16 / 9),
            ),
            const SizedBox(height: 8),
            const Text('Precisa de internet para assistir.'),
            TextButton.icon(
              onPressed: () => abrirNoYoutube(widget.videoId),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Não abriu? Abrir no YouTube'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> abrirNoYoutube(String videoId) => launchUrl(
  Uri.parse('https://www.youtube.com/watch?v=$videoId'),
  mode: LaunchMode.externalApplication,
);

Future<void> buscarNoYoutube(String busca) => launchUrl(
  Uri.https('www.youtube.com', '/results', {'search_query': busca}),
  mode: LaunchMode.externalApplication,
);
