import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

/// Sons curtos do app, gerados no código (não precisa de arquivo de áudio).
class SoundService {
  late final AudioPlayer _player = AudioPlayer();
  Uint8List? _alerta;

  /// Alerta suave de três tons usado no SOS.
  Future<void> tocarAlerta() async {
    try {
      _alerta ??= gerarAlerta();
      await _player.stop();
      await _player.play(BytesSource(_alerta!, mimeType: 'audio/wav'));
    } catch (_) {}
  }

  /// Três tons senoidais (440, 520 e 440 Hz) que vão diminuindo de volume.
  static Uint8List gerarAlerta() => _wav(const [
    (440.0, 0.0, 0.3, 0.25),
    (520.0, 0.25, 0.3, 0.25),
    (440.0, 0.5, 0.4, 0.2),
  ]);

  // Cada tom: (frequência Hz, início s, duração s, volume).
  static Uint8List _wav(List<(double, double, double, double)> tons) {
    const taxa = 22050;
    final fim = tons.map((t) => t.$2 + t.$3).reduce(max);
    final n = (fim * taxa).ceil();
    final mix = List<double>.filled(n, 0);
    for (final (freq, inicio, dur, vol) in tons) {
      final a = (inicio * taxa).floor();
      final b = min(n, ((inicio + dur) * taxa).floor());
      for (var i = a; i < b; i++) {
        final t = (i - a) / taxa;
        final ganho = vol * pow(0.01 / vol, t / dur); // some aos poucos
        mix[i] += sin(2 * pi * freq * t) * ganho;
      }
    }
    final dados = ByteData(44 + n * 2);
    void txt(int pos, String s) {
      for (var i = 0; i < s.length; i++) {
        dados.setUint8(pos + i, s.codeUnitAt(i));
      }
    }

    txt(0, 'RIFF');
    dados.setUint32(4, 36 + n * 2, Endian.little);
    txt(8, 'WAVEfmt ');
    dados.setUint32(16, 16, Endian.little);
    dados.setUint16(20, 1, Endian.little); // PCM
    dados.setUint16(22, 1, Endian.little); // mono
    dados.setUint32(24, taxa, Endian.little);
    dados.setUint32(28, taxa * 2, Endian.little);
    dados.setUint16(32, 2, Endian.little);
    dados.setUint16(34, 16, Endian.little);
    txt(36, 'data');
    dados.setUint32(40, n * 2, Endian.little);
    for (var i = 0; i < n; i++) {
      final v = (mix[i].clamp(-1.0, 1.0) * 32767).round();
      dados.setInt16(44 + i * 2, v, Endian.little);
    }
    return dados.buffer.asUint8List();
  }
}
