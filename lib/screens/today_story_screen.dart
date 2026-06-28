import 'package:flutter/material.dart';

class TodayStoryScreen extends StatefulWidget {
  final String languageCode;

  const TodayStoryScreen({
    super.key,
    required this.languageCode,
  });

  @override
  State<TodayStoryScreen> createState() => _TodayStoryScreenState();
}

class _TodayStoryScreenState extends State<TodayStoryScreen> {
  final TextEditingController sadController = TextEditingController();
  final TextEditingController happyController = TextEditingController();
  final TextEditingController personController = TextEditingController();
  final TextEditingController feelingController = TextEditingController();

  double stres = 5;
  double mutluluk = 5;
  double enerji = 5;

  bool get isEn => widget.languageCode == 'en';

  String t(String tr, String en) {
    return isEn ? en : tr;
  }

  void analyzeDay() {
    String title = t('Dengeli Gün', 'Balanced Day');

    if (stres >= 8 && enerji <= 4) {
      title = t('Duygusal Yorgunluk', 'Emotional Fatigue');
    } else if (stres >= 8) {
      title = t('Yüksek Stres', 'High Stress');
    } else if (mutluluk >= 8 && enerji >= 6) {
      title = t('İyi Gün', 'Good Day');
    } else if (enerji <= 3) {
      title = t('Düşük Enerji', 'Low Energy');
    }

    final message = '${t('Stres', 'Stress')}: ${stres.round()}/10\n'
        '${t('Mutluluk', 'Happiness')}: ${mutluluk.round()}/10\n'
        '${t('Enerji', 'Energy')}: ${enerji.round()}/10\n\n'
        '${t(
      'Bugün yaşadıkların seni etkilemiş görünüyor. Kendini suçlamadan, ne hissettiğini anlamaya çalış.',
      'What you experienced today seems to have affected you. Try to understand what you feel without blaming yourself.',
    )}';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('Tamam', 'OK')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    sadController.dispose();
    happyController.dispose();
    personController.dispose();
    feelingController.dispose();
    super.dispose();
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildSlider(
    String title,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text('$title: ${value.round()}/10'),
          Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('🌙 Bugün Ne Yaşadın?', '🌙 What Happened Today?')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(
              t(
                'Bugün seni en çok ne üzdü?',
                'What upset you the most today?',
              ),
              sadController,
            ),
            buildField(
              t(
                'Bugün seni en çok ne mutlu etti?',
                'What made you happiest today?',
              ),
              happyController,
            ),
            buildField(
              t(
                'Kiminle sorun yaşadın?',
                'Who did you have a problem with?',
              ),
              personController,
            ),
            buildField(
              t(
                'Bu konuda ne hissediyorsun?',
                'How do you feel about this?',
              ),
              feelingController,
            ),
            buildSlider(
              t('Stres Seviyesi', 'Stress Level'),
              stres,
              (v) {
                setState(() => stres = v);
              },
            ),
            buildSlider(
              t('Mutluluk Seviyesi', 'Happiness Level'),
              mutluluk,
              (v) {
                setState(() => mutluluk = v);
              },
            ),
            buildSlider(
              t('Enerji Seviyesi', 'Energy Level'),
              enerji,
              (v) {
                setState(() => enerji = v);
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: analyzeDay,
                child: Text(t('Günü Analiz Et', 'Analyze the Day')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
