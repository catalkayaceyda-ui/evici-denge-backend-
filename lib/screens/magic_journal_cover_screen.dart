import 'package:flutter/material.dart';
import 'magic_journal_list_screen.dart';

class MagicJournalCoverScreen extends StatelessWidget {
  final String languageCode;

  const MagicJournalCoverScreen({
    super.key,
    required this.languageCode,
  });

  String t(String tr, String en) {
    return languageCode == 'en' ? en : tr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0F08),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MagicJournalListScreen(
                      languageCode: languageCode,
                    ),
                  ),
                );
              },
              child: Image.asset(
                'assets/images/journal_cover.png',
                width: 420,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 260,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MagicJournalListScreen(
                        languageCode: languageCode,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
                label: Text(
                  t(
                    'Geçmiş Günlüklerim',
                    'My Previous Journals',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
