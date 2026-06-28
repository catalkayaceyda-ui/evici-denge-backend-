import 'package:flutter/material.dart';
import '../widgets/menu_button.dart';
import 'relationship_test_screen.dart';
import 'today_story_screen.dart';
import 'ready_answers_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String title;
  final String icon;
  final String languageCode;

  const CategoryScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.languageCode,
  });

  String t(String tr, String en) {
    return languageCode == 'en' ? en : tr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 70)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            MenuButton(
              text: t('💗 İlişki Testi', '💗 Relationship Test'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RelationshipTestScreen(
                      categoryTitle: title,
                      languageCode: languageCode,
                    ),
                  ),
                );
              },
            ),
            MenuButton(
              text: t('💬 Hazır Cevaplar', '💬 Ready Answers'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReadyAnswersScreen(
                      categoryTitle: title,
                      languageCode: languageCode,
                    ),
                  ),
                );
              },
            ),
            MenuButton(
              text: t('🌙 Bugün Ne Yaşadın?', '🌙 What Happened Today?'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TodayStoryScreen(
                      languageCode: languageCode,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
