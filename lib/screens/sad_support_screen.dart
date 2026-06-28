import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SadSupportScreen extends StatefulWidget {
  final String languageCode;

  const SadSupportScreen({
    super.key,
    this.languageCode = 'tr',
  });

  @override
  State<SadSupportScreen> createState() => _SadSupportScreenState();
}

class _SadSupportScreenState extends State<SadSupportScreen> {
  final TextEditingController noteController = TextEditingController();

  late stt.SpeechToText speech;
  bool isListening = false;
  String statusText = '';

  bool get isEn => widget.languageCode == 'en';

  String t(String tr, String en) {
    return isEn ? en : tr;
  }

  List<String> get messages => isEn
      ? [
          'This feeling will not last forever.',
          'You do not have to be strong today.',
          'Slowing down is also progress.',
          'Be kind to yourself.',
          'Today, just breathing may be enough.',
        ]
      : [
          'Bu his sonsuza kadar sürmeyecek.',
          'Bugün güçlü olmak zorunda değilsin.',
          'Yavaşlamak da bir ilerlemedir.',
          'Kendine karşı nazik ol.',
          'Bugün sadece nefes almak bile yeterli olabilir.',
        ];

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();

    statusText = t(
      'Konuşmaya başlamak için mikrofona bas.',
      'Press the microphone to start speaking.',
    );
  }

  Future<void> startListening() async {
    final available = await speech.initialize();

    if (!available) {
      setState(() {
        statusText = t(
          'Mikrofon izni alınamadı.',
          'Microphone permission not granted.',
        );
      });
      return;
    }

    setState(() {
      isListening = true;
      statusText = t(
        'Dinliyorum... Konuşabilirsin.',
        'Listening... You can speak now.',
      );
    });

    speech.listen(
      localeId: isEn ? 'en_US' : 'tr_TR',
      onResult: (result) {
        setState(() {
          noteController.text = result.recognizedWords;
          noteController.selection = TextSelection.fromPosition(
            TextPosition(offset: noteController.text.length),
          );
        });
      },
    );
  }

  void stopListening() {
    speech.stop();

    setState(() {
      isListening = false;
      statusText = t(
        'Dinleme durdu.',
        'Listening stopped.',
      );
    });
  }

  @override
  void dispose() {
    noteController.dispose();
    speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEn ? '😔 I Feel Sad' : '😔 Üzgünüm',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              t('Güvenli Alan', 'Safe Space'),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              t(
                'Şu an üzgün hissetmen normal. Burada kendini açıklamak zorunda değilsin. Sadece içinden geçeni bırakabilirsin.',
                'Feeling sad right now is normal. You do not need to explain yourself here. Just let your thoughts flow.',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                t(
                  '4 saniye nefes al\n4 saniye tut\n6 saniye ver\n\nBunu 3 kez tekrarla.',
                  'Breathe in for 4 seconds\nHold for 4 seconds\nExhale for 6 seconds\n\nRepeat 3 times.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              t('İçini Dök', 'Express Yourself'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: t(
                  'Şu an seni en çok ne üzüyor?',
                  'What is upsetting you the most right now?',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isListening ? stopListening : startListening,
                icon: Icon(isListening ? Icons.stop : Icons.mic),
                label: Text(
                  isListening
                      ? t('Dinlemeyi Durdur', 'Stop Listening')
                      : t('🎙 Konuşarak Yaz', '🎙 Voice Input'),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              t(
                'Sana Söylemek İstediğim',
                'A Message For You',
              ),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...messages.map(
              (msg) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(msg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
