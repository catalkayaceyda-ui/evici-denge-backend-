import 'package:flutter/material.dart';
import '../main.dart';
import 'category_screen.dart';
import 'emotion_support_screen.dart';
import 'pin_lock_screen.dart';
import 'magic_journal_cover_screen.dart';
import 'comments_screen.dart';
import 'analysis_screen.dart';
import 'profile_screen.dart';
import 'online_together_game_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(Color color, ThemeMode mode)? onThemeChanged;
  final String languageCode;
  final void Function(String code)? onLanguageChanged;

  const HomeScreen({
    super.key,
    this.onThemeChanged,
    required this.languageCode,
    this.onLanguageChanged,
  });

  String t(String tr, String en) {
    return languageCode == 'en' ? en : tr;
  }

  String greetingText() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return t('Günaydın ☀️', 'Good Morning ☀️');
    } else if (hour >= 12 && hour < 18) {
      return t('İyi günler 🌿', 'Good Afternoon 🌿');
    } else if (hour >= 18 && hour < 24) {
      return t('İyi akşamlar 🌙', 'Good Evening 🌙');
    } else {
      return t('İyi geceler 🌌', 'Good Night 🌌');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'titleKey': 'spouse', 'icon': '❤️', 'color': Colors.pink},
      {'titleKey': 'motherInLaw', 'icon': '👵', 'color': Colors.deepPurple},
      {'titleKey': 'brideGuide', 'icon': '👰', 'color': Colors.orange},
      {'titleKey': 'sisterInLaw', 'icon': '👭', 'color': Colors.teal},
      {'titleKey': 'coSisterInLaw', 'icon': '🤝', 'color': Colors.blue},
      {'titleKey': 'children', 'icon': '👶', 'color': Colors.redAccent},
      {'titleKey': 'emotionWorld', 'icon': '🎨', 'color': Colors.indigo},
      {'titleKey': 'emotionSupport', 'icon': '🌙', 'color': Colors.green},
      {'titleKey': 'emotionJournal', 'icon': '📔', 'color': Colors.purple},
      {'titleKey': 'comments', 'icon': '💬', 'color': Colors.amber},
      {'titleKey': 'togetherGame', 'icon': '🎮', 'color': Colors.cyan},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F0),
      appBar: AppBar(
        title: Text(appText(languageCode, 'appTitle')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('🇹🇷 Türkçe'),
                      onTap: () {
                        onLanguageChanged?.call('tr');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('🇺🇸 English'),
                      onTap: () {
                        onLanguageChanged?.call('en');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PinLockScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.spa, color: Colors.teal),
                        title: Text(appText(languageCode, 'calmTheme')),
                        onTap: () {
                          onThemeChanged?.call(Colors.teal, ThemeMode.light);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.favorite, color: Colors.pink),
                        title: Text(appText(languageCode, 'pinkTheme')),
                        onTap: () {
                          onThemeChanged?.call(Colors.pink, ThemeMode.light);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.auto_awesome,
                          color: Colors.deepPurple,
                        ),
                        title: Text(appText(languageCode, 'lavenderTheme')),
                        onTap: () {
                          onThemeChanged?.call(
                            Colors.deepPurple,
                            ThemeMode.light,
                          );
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.dark_mode),
                        title: Text(appText(languageCode, 'darkTheme')),
                        onTap: () {
                          onThemeChanged?.call(Colors.teal, ThemeMode.dark);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(10, 8, 10, 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF758C),
                  Color(0xFFFF7EB3),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('👤 Profilim', '👤 My Profile'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  greetingText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  t('Bugün nasılsın?', 'How are you today?'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final String titleKey = items[index]['titleKey'];
                final String title = titleKey == 'togetherGame'
                    ? t('Birlikte Oyna', 'Play Together')
                    : appText(languageCode, titleKey);

                final String icon = items[index]['icon'];
                final Color color = items[index]['color'];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.70),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (titleKey == 'emotionWorld') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AnalysisScreen(
                              languageCode: languageCode,
                            ),
                          ),
                        );
                      } else if (titleKey == 'emotionSupport') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmotionSupportScreen(
                              languageCode: languageCode,
                            ),
                          ),
                        );
                      } else if (titleKey == 'emotionJournal') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MagicJournalCoverScreen(
                              languageCode: languageCode,
                            ),
                          ),
                        );
                      } else if (titleKey == 'comments') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommentsScreen(
                              languageCode: languageCode,
                            ),
                          ),
                        );
                      } else if (titleKey == 'togetherGame') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OnlineTogetherGameScreen(
                              languageCode: languageCode,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryScreen(
                              title: title,
                              icon: icon,
                              languageCode: languageCode,
                            ),
                          ),
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          icon,
                          style: const TextStyle(fontSize: 34),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
