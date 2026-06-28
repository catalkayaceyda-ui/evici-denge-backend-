import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmotionDetailScreen extends StatefulWidget {
  final String title;
  final String icon;
  final String message;
  final String languageCode;

  const EmotionDetailScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.message,
    this.languageCode = 'tr',
  });

  @override
  State<EmotionDetailScreen> createState() => _EmotionDetailScreenState();
}

class _EmotionDetailScreenState extends State<EmotionDetailScreen> {
  final TextEditingController problemController = TextEditingController();

  bool isLoading = false;
  String aiAnswer = '';

  bool get isEn => widget.languageCode == 'en';

  String t(String tr, String en) {
    return isEn ? en : tr;
  }

  Future<void> getAiSupport() async {
    final problem = problemController.text.trim();

    if (problem.isEmpty) {
      setState(() {
        aiAnswer = t(
          'Lütfen önce sorununu yaz.',
          'Please write your problem first.',
        );
      });
      return;
    }

    setState(() {
      isLoading = true;
      aiAnswer = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/ai-support'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': widget.title,
          'message': isEn
              ? 'Please answer in English.\n\n${widget.message}\n\nUser message:\n$problem'
              : '${widget.message}\n\nKullanıcının mesajı:\n$problem',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          aiAnswer = data['answer'] ??
              data['reply'] ??
              data['message'] ??
              t('AI cevabı alınamadı.', 'AI response could not be received.');
        });
      } else {
        setState(() {
          aiAnswer = t(
            'AI şu an cevap veremiyor. Biraz sonra tekrar dene.',
            'AI is unavailable right now. Please try again later.',
          );
        });
      }
    } catch (e) {
      setState(() {
        aiAnswer = t(
          'Bağlantı hatası. Backend açık mı kontrol et.',
          'Connection error. Please check if the backend is running.',
        );
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F0),
      appBar: AppBar(
        title: Text('${widget.icon} ${widget.title}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              t(
                'Bu konuyu biraz daha detaylı anlatmak istersen buraya yaz. AI sana sakin, destekleyici ve uygulanabilir öneriler sunsun.',
                'If you would like to explain this situation in more detail, write below. Let AI provide calm, supportive and practical suggestions.',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: problemController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: t('Sorununu yaz', 'Write your problem'),
                hintText: t(
                  'Şu an ne yaşıyorsun?',
                  'What are you experiencing right now?',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : getAiSupport,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.smart_toy),
                label: Text(
                  isLoading
                      ? t('Hazırlanıyor...', 'Preparing...')
                      : t('AI Destek Al', 'Get AI Support'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (aiAnswer.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepPurple.shade100),
                ),
                child: Text(
                  aiAnswer,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
