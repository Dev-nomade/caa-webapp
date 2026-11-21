import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme.dart';
import 'core/tts_service.dart';
import 'features/crianca/home_page.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(CognitiaApp(estado: AppState(TtsService(), prefs)));
}

class CognitiaApp extends StatelessWidget {
  const CognitiaApp({super.key, required this.estado});
  final AppState estado;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: estado,
      child: Consumer<AppState>(
        builder: (_, s, _) => MaterialApp(
          title: 'CognitIA',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(altoContraste: s.altoContraste, escuro: s.escuro),
          home: const HomePage(),
        ),
      ),
    );
  }
}
