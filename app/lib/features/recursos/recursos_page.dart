import 'package:material_ui/material_ui.dart';

import '../../data/recursos.dart';
import '../widgets/video_dialog.dart';

/// Botão "Vídeo": desenhos (Peppa Pig, Masha e o Urso, Ursinho Pooh).
class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Vídeo')),
    body: ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const _Aviso('Desenhos para assistir. Precisam de internet.'),
        for (final g in gruposVideos) _SecaoVideos(g),
      ],
    ),
  );
}

/// Botão "Música": alfabeto musical e músicas para relaxar.
class MusicasPage extends StatelessWidget {
  const MusicasPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Música')),
    body: ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const _Aviso('Músicas para cantar e aprender. Precisam de internet.'),
        const _SecaoVideos(musicasAlfabeto),
        const _Titulo('🌿', 'Para relaxar'),
        for (final m in musicasRelaxantes)
          _Linha(titulo: m.titulo, subtitulo: m.artista, videoId: m.videoId),
      ],
    ),
  );
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

class _Aviso extends StatelessWidget {
  const _Aviso(this.texto);
  final String texto;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Text(texto, style: const TextStyle(fontSize: 18)),
  );
}

class _Titulo extends StatelessWidget {
  const _Titulo(this.emoji, this.texto);
  final String emoji, texto;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
    child: Text(
      '$emoji  $texto',
      style: Theme.of(context).textTheme.titleMedium,
    ),
  );
}

class _Linha extends StatelessWidget {
  const _Linha({required this.titulo, required this.videoId, this.subtitulo});
  final String titulo, videoId;
  final String? subtitulo;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: const Icon(Icons.play_circle_fill, size: 44),
      title: Text(titulo, style: const TextStyle(fontSize: 19)),
      subtitle: subtitulo == null ? null : Text(subtitulo!),
      onTap: () => mostrarVideo(context, videoId, titulo: titulo),
    ),
  );
}

class _SecaoVideos extends StatelessWidget {
  const _SecaoVideos(this.grupo);
  final GrupoVideos grupo;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Titulo(grupo.emoji, grupo.nome),
      for (final v in grupo.itens) _Linha(titulo: v.titulo, videoId: v.videoId),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => buscarNoYoutube(grupo.busca),
          icon: const Icon(Icons.search),
          label: Text('Ver mais de ${grupo.nome} no YouTube'),
        ),
      ),
    ],
  );
}
