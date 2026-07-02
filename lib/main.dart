import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/notes_list_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amar Notes',
      // Both themes are built from scratch (see lib/theme/).
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Follow the device's system theme by default.
      themeMode: ThemeMode.system,
      home: const NotesListScreen(),
    );
  }
}