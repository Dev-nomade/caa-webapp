import 'package:url_launcher/url_launcher.dart';

/// Abre o vídeo no YouTube de verdade: numa nova aba (site) ou no app do
/// YouTube (celular). Lá funcionam play, pause, pular anúncio e tela cheia.
Future<void> abrirNoYoutube(String videoId) =>
    _abrir(Uri.https('www.youtube.com', '/watch', {'v': videoId}));

Future<void> _abrir(Uri uri) async {
  try {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  } catch (_) {}
}
