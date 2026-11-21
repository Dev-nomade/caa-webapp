import 'package:material_ui/material_ui.dart';

ThemeData buildTheme({bool altoContraste = false}) {
  final base = ColorScheme.fromSeed(
    seedColor: const Color(0xFF5B8DB8),
    brightness: Brightness.light,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: base,
    scaffoldBackgroundColor:
        altoContraste ? Colors.white : const Color(0xFFF7F4EE), // fundo pastel
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 20),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 64), // alvo de toque grande
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );
}
