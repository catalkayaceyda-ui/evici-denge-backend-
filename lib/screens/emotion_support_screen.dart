import 'package:flutter/material.dart';
import 'sad_support_screen.dart';
import 'emotion_detail_screen.dart';

class EmotionSupportScreen extends StatelessWidget {
  final String languageCode;

  const EmotionSupportScreen({
    super.key,
    this.languageCode = 'tr',
  });

  bool get isEn => languageCode == 'en';

  String t(String tr, String en) {
    return isEn ? en : tr;
  }

  List<Map<String, String>> get emotions => [
        {
          'title': t('Üzgünüm', 'I Feel Sad'),
          'icon': '😔',
          'message': t(
            'İçini dökebileceğin, nefes alabileceğin güvenli alan.',
            'A safe space where you can open your heart and breathe.',
          ),
          'key': 'sad',
        },
        {
          'title': t('Mutluyum', 'I Feel Happy'),
          'icon': '😊',
          'message': t(
            'Bu güzel duyguyu fark et. Bugün seni mutlu eden şeyi kaybetme, onu büyüt.',
            'Notice this beautiful feeling. Do not lose what made you happy today; let it grow.',
          ),
          'key': 'happy',
        },
        {
          'title': t('Sevinçliyim', 'I Feel Joyful'),
          'icon': '🎉',
          'message': t(
            'Sevincini saklama. Güvendiğin biriyle paylaşmak bu güzel duyguyu güçlendirir.',
            'Do not hide your joy. Sharing it with someone you trust can make this feeling stronger.',
          ),
          'key': 'joy',
        },
        {
          'title': t('Ayrılık Yaşıyorum', 'I Am Going Through a Breakup'),
          'icon': '💔',
          'message': t(
            'Ayrılık acısı zaman ister. Bugün kendini suçlama. Önce sakinleş, sonra karar ver.',
            'The pain of separation takes time. Do not blame yourself today. Calm down first, then decide.',
          ),
          'key': 'breakup',
        },
        {
          'title': t('Stresliyim', 'I Feel Stressed'),
          'icon': '😩',
          'message': t(
            'Her şeyi bugün çözmek zorunda değilsin. Önce bedenini sakinleştir, sonra zihnin de yavaşlar.',
            'You do not have to solve everything today. Calm your body first, and your mind will slow down too.',
          ),
          'key': 'stress',
        },
        {
          'title': t('Öfkeliyim', 'I Feel Angry'),
          'icon': '😡',
          'message': t(
            'Öfkeliyken verilen cevaplar çoğu zaman pişmanlık getirir. Önce dur, sonra konuş.',
            'Answers given in anger often bring regret. Pause first, then speak.',
          ),
          'key': 'anger',
        },
        {
          'title': t('Yalnız Hissediyorum', 'I Feel Lonely'),
          'icon': '🥺',
          'message': t(
            'Yalnız hissetmen değersiz olduğun anlamına gelmez. Küçük bir temas bile kalbine iyi gelebilir.',
            'Feeling lonely does not mean you are worthless. Even a small connection can comfort your heart.',
          ),
          'key': 'lonely',
        },
        {
          'title': t('Manevi Destek', 'Spiritual Support'),
          'icon': '🙏',
          'message': t(
            'İçin daraldığında dua etmek, tesbih çekmek veya sessizce oturmak kalbine iyi gelebilir.',
            'When your heart feels heavy, praying, meditating, or sitting quietly may comfort you.',
          ),
          'key': 'spiritual',
        },
      ];

  void openEmotion(BuildContext context, Map<String, String> item) {
    if (item['key'] == 'sad') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SadSupportScreen(languageCode: languageCode),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EmotionDetailScreen(
            title: item['title']!,
            icon: item['icon']!,
            message: item['message']!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emotionItems = emotions;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('Duyguya Göre Destek', 'Emotion-Based Support')),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: emotionItems.length,
        itemBuilder: (context, index) {
          final item = emotionItems[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              onTap: () => openEmotion(context, item),
              leading: Text(
                item['icon']!,
                style: const TextStyle(fontSize: 34),
              ),
              title: Text(
                item['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['message']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
    );
  }
}
