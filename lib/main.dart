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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Starts in `system` so the user's device preference is respected on
  /// first launch. The toggle button in the list screen can switch to
  /// `light` or `dark` explicitly.
  ThemeMode _themeMode = ThemeMode.system;

  void _cycleThemeMode() {
    setState(() {
      // Cycle: system → light → dark → system → ...
      _themeMode = switch (_themeMode) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amar Notes',
      // Both themes are built from scratch (see lib/theme/).
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      // Hide the red "DEBUG" banner in the top-right corner.
      debugShowCheckedModeBanner: false,
      home: NotesListScreen(
        themeMode: _themeMode,
        onToggleTheme: _cycleThemeMode,
      ),
    );
  }
}