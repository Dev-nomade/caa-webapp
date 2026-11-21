import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Fotos e gravações de voz dos cartões personalizados.
/// Tudo é copiado para a pasta privada do app: nada sai do aparelho.
class MediaService {
  late final ImagePicker _picker = ImagePicker();
  late final AudioRecorder _recorder = AudioRecorder();
  late final AudioPlayer _player = AudioPlayer();

  Future<Directory> _pasta() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/midia');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<String> _novoCaminho(String prefixo, String ext) async =>
      '${(await _pasta()).path}/${prefixo}_${DateTime.now().millisecondsSinceEpoch}.$ext';

  /// Abre câmera ou galeria e devolve o caminho da cópia salva (ou null).
  Future<String?> escolherFoto(ImageSource origem) async {
    final x = await _picker.pickImage(
      source: origem,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (x == null) return null;
    final destino = await _novoCaminho('foto', 'jpg');
    await File(x.path).copy(destino);
    return destino;
  }

  /// Começa a gravar. Devolve false se o usuário negou o microfone.
  Future<bool> iniciarGravacao() async {
    if (!await _recorder.hasPermission()) return false;
    final caminho = await _novoCaminho('voz', 'm4a');
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: caminho,
    );
    return true;
  }

  Future<String?> pararGravacao() => _recorder.stop();

  Future<void> tocar(String caminho) async {
    try {
      await _player.stop();
      await _player.play(DeviceFileSource(caminho));
    } catch (_) {}
  }

  Future<void> apagar(String? caminho) async {
    if (caminho == null) return;
    try {
      final f = File(caminho);
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}
