import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://lebxxelktgnycojwdiwl.supabase.co',
    anonKey: 'sb_publishable__jVYgKrh8jsSSONSeUO-Cg_RYIXwd_s',
  );

  runApp(const EvIciDengeApp());
}

class EvIciDengeApp extends StatefulWidget {
  const EvIciDengeApp({super.key});

  @override
  State<EvIciDengeApp> createState() => _EvIciDengeAppState();
}

class _EvIciDengeAppState extends State<EvIciDengeApp> {
  Color themeColor = const Color(0xFF8E7CC3);
  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'tr';

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      languageCode = prefs.getString('language') ?? 'tr';
    });
  }

  void changeTheme(Color color, ThemeMode mode) {
    setState(() {
      themeColor = color;
      themeMode = mode;
    });
  }

  Future<void> changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);
    setState(() {
      languageCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appText(languageCode, 'appTitle'),
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: themeColor,
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F4FF),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: themeColor,
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1A2E),
      ),
      home: SplashScreen(
        languageCode: languageCode,
        onThemeChanged: changeTheme,
        onLanguageChanged: changeLanguage,
      ),
    );
  }
}

String appText(String lang, String key) {
  final data = appTranslations[lang] ?? appTranslations['tr']!;
  return data[key] ?? appTranslations['tr']![key] ?? key;
}

final Map<String, Map<String, String>> appTranslations = {
  'tr': {
    'appTitle': 'Ev İçi Denge',
    'spouse': 'Eşimle İlişkim',
    'motherInLaw': 'Kaynanamla İlişkim',
    'brideGuide': 'Gelin Rehberi',
    'sisterInLaw': 'Görümce İlişkileri',
    'coSisterInLaw': 'Elti İlişkileri',
    'children': 'Çocuklarla İletişim',
    'emotionWorld': 'Duygu Dünyam',
    'emotionSupport': 'Duyguya Göre Destek',
    'emotionJournal': 'Duygu Günlüğüm',
    'comments': 'Yorumlar',
    'togetherGame': 'Birlikte Oyna',
    'language': 'Dil',
    'theme': 'Tema',
    'calmTheme': '🌿 Sakin Tema',
    'pinkTheme': '🌸 Pembe Tema',
    'lavenderTheme': '💜 Lavanta Tema',
    'darkTheme': '🌙 Koyu Tema',
  },
  'en': {
    'appTitle': 'Home Balance',
    'spouse': 'My Relationship with My Spouse',
    'motherInLaw': 'My Relationship with My Mother-in-law',
    'brideGuide': 'Bride Guide',
    'sisterInLaw': 'Sister-in-law Relations',
    'coSisterInLaw': 'Co-sister Relations',
    'children': 'Communication with Children',
    'emotionWorld': 'My Emotion World',
    'emotionSupport': 'Emotion-Based Support',
    'emotionJournal': 'Emotion Journal',
    'comments': 'Comments',
    'togetherGame': 'Play Together',
    'language': 'Language',
    'theme': 'Theme',
    'calmTheme': '🌿 Calm Theme',
    'pinkTheme': '🌸 Pink Theme',
    'lavenderTheme': '💜 Lavender Theme',
    'darkTheme': '🌙 Dark Theme',
  },
};
