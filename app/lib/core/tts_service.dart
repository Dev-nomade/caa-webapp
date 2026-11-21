import 'package:flutter_tts/flutter_tts.dart';

/// Fala em português do Brasil usando a voz do próprio celular (funciona offline).
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _pronto = false;

  Future<void> _init() async {
    if (_pronto) return;
    try {
      await _tts.setLanguage('pt-BR');
      await _tts.setSpeechRate(0.45); // devagar e claro
      await _tts.setPitch(1.0);
    } catch (_) {}
    _pronto = true;
  }

  Future<void> falar(String texto) async {
    await _init();
    try {
      await _tts.stop();
      await _tts.speak(texto);
    } catch (_) {}
  }

  Future<void> parar() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
