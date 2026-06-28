import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'magic_journal_detail_screen.dart';

class MagicJournalListScreen extends StatefulWidget {
  final String languageCode;

  const MagicJournalListScreen({
    super.key,
    required this.languageCode,
  });

  @override
  State<MagicJournalListScreen> createState() => _MagicJournalListScreenState();
}

class _MagicJournalListScreenState extends State<MagicJournalListScreen> {
  List<Map<String, dynamic>> journals = [];

  bool get isEn => widget.languageCode == 'en';

  String t(String tr, String en) {
    return isEn ? en : tr;
  }

  @override
  void initState() {
    super.initState();
    loadJournals();
  }

  Future<void> loadJournals() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('magic_journals') ?? [];

    setState(() {
      journals = savedList
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList()
          .reversed
          .toList();
    });
  }

  Future<void> deleteJournal(int reversedIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('magic_journals') ?? [];

    final realIndex = savedList.length - 1 - reversedIndex;

    if (realIndex >= 0 && realIndex < savedList.length) {
      savedList.removeAt(realIndex);
      await prefs.setStringList('magic_journals', savedList);
      await loadJournals();
    }
  }

  String shortText(String text) {
    if (text.length <= 60) return text;
    return '${text.substring(0, 60)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B160B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: const Color(0xFFFFD54F),
        title: Text(
          t('📖 Günlüklerim', '📖 My Journals'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MagicJournalDetailScreen(
                    languageCode: widget.languageCode,
                  ),
                ),
              );
              loadJournals();
            },
          ),
        ],
      ),
      body: journals.isEmpty
          ? Center(
              child: Text(
                t(
                  'Henüz günlük kaydı yok.',
                  'No journal entries yet.',
                ),
                style: const TextStyle(
                  color: Color(0xFFFFECB3),
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: journals.length,
              itemBuilder: (context, index) {
                final item = journals[index];

                return Card(
                  color: const Color(0xFFF5E6C8),
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: Text(
                      item['emoji'] ?? '😊',
                      style: const TextStyle(fontSize: 30),
                    ),
                    title: Text(
                      item['date'] ?? t('Tarih yok', 'No date'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      shortText(item['text'] ?? ''),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.brown),
                      onPressed: () => deleteJournal(index),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MagicJournalDetailScreen(
                            existingJournal: item,
                            reversedIndex: index,
                            languageCode: widget.languageCode,
                          ),
                        ),
                      );
                      loadJournals();
                    },
                  ),
                );
              },
            ),
    );
  }
}
