import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/store.dart';
import 'features/shell/shell_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await store.load();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (_, __) => MaterialApp(
          title: 'Meu Bolso',
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          darkTheme: appTheme,
          themeMode: ThemeMode.dark,
          home: Shell(),
        ),
      );
}
