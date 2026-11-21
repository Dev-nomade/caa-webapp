import 'package:url_launcher/url_launcher.dart';

/// Abre o vídeo no YouTube de verdade: numa nova aba (site) ou no app do
/// YouTube (celular). Lá funcionam play, pause, pular anúncio e tela cheia.
Future<void> abrirNoYoutube(String videoId) =>
    _abrir(Uri.https('www.youtube.com', '/watch', {'v': videoId}));

/// Abre uma busca no YouTube (para achar mais vídeos).
Future<void> buscarNoYoutube(String busca) =>
    _abrir(Uri.https('www.youtube.com', '/results', {'search_query': busca}));

Future<void> _abrir(Uri uri) async {
  try {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  } catch (_) {}
}
