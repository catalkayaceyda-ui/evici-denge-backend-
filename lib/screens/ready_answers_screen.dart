import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'emotion_detail_screen.dart';

class ReadyAnswersScreen extends StatelessWidget {
  final String categoryTitle;
  final String languageCode;

  const ReadyAnswersScreen({
    super.key,
    required this.categoryTitle,
    required this.languageCode,
  });

  bool get isEn => languageCode == 'en';

  String t(String tr, String en) => isEn ? en : tr;

  List<Map<String, String>> getAnswers() {
    final title = categoryTitle.toLowerCase();

    if (title.contains('kaynana') || title.contains('mother-in-law')) {
      return kaynanaAnswers;
    } else if (title.contains('gelin') || title.contains('bride')) {
      return gelinAnswers;
    } else if (title.contains('görümce') || title.contains('sister-in-law')) {
      return gorumceAnswers;
    } else if (title.contains('elti') || title.contains('co-sister')) {
      return eltiAnswers;
    } else if (title.contains('çocuk') || title.contains('children')) {
      return cocukAnswers;
    } else if (title.contains('eş') ||
        title.contains('spouse') ||
        title.contains('partner')) {
      return esAnswers;
    } else {
      return genelAnswers;
    }
  }

  String itemText(Map<String, String> item, String key) {
    if (isEn) {
      return item['${key}En'] ?? item[key] ?? '';
    }
    return item[key] ?? '';
  }

  void copyAnswer(BuildContext context, Map<String, String> item) {
    final text = '${itemText(item, 'situation')}\n\n'
        '${t('Yumuşak Başlangıç', 'Soft Start')}:\n${itemText(item, 'soft')}\n\n'
        '${t('Sınır Koyan Cevap', 'Boundary Setting Response')}:\n${itemText(item, 'boundary')}\n\n'
        '${t('Konuyu Sakinleştiren Cevap', 'Calming Response')}:\n${itemText(item, 'calm')}';

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t('Cevap kopyalandı', 'Answer copied'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final answers = getAnswers();

    return Scaffold(
      appBar: AppBar(
        title:
            Text(isEn ? '$categoryTitle Answers' : '$categoryTitle Cevapları'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: answers.length,
        itemBuilder: (context, index) {
          final item = answers[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemText(item, 'situation'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t('Yumuşak Başlangıç', 'Soft Start'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(itemText(item, 'soft')),
                  const SizedBox(height: 10),
                  Text(
                    t('Sınır Koyan Cevap', 'Boundary Setting Response'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(itemText(item, 'boundary')),
                  const SizedBox(height: 10),
                  Text(
                    t('Konuyu Sakinleştiren Cevap', 'Calming Response'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(itemText(item, 'calm')),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => copyAnswer(context, item),
                      icon: const Icon(Icons.copy),
                      label: Text(t('Cevapları Kopyala', 'Copy Answers')),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.smart_toy),
                      label:
                          Text(t('AI Destekten Yardım Al', 'Get AI Support')),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmotionDetailScreen(
                              title: categoryTitle,
                              icon: '🤝',
                              message: itemText(item, 'calm'),
                              languageCode: languageCode,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

const List<Map<String, String>> kaynanaAnswers = [
  {
    'situation': 'Çocuk yetiştirmeye karışıyor',
    'situationEn': 'She interferes with parenting',
    'soft':
        'Tecrübenizi önemsiyorum, ama bu konuda çocuğumuz için kendi düzenimizi kurmaya çalışıyoruz.',
    'softEn':
        'I value your experience, but we are trying to create our own routine for our child.',
    'boundary': 'Bu konuda anne-baba olarak kararı biz vermek istiyoruz.',
    'boundaryEn':
        'As parents, we want to make the decision on this matter ourselves.',
    'calm':
        'Fikrinizi aldım, eşimle konuşup bize en uygun olanı uygulayacağız.',
    'calmEn':
        'I understand your opinion. I will discuss it with my spouse and we will do what works best for us.',
  },
  {
    'situation': 'Ev düzenini eleştiriyor',
    'situationEn': 'She criticizes the home order',
    'soft':
        'Sizin düzen anlayışınızı anlıyorum, bizim evimizde ise böyle daha rahat ediyoruz.',
    'softEn':
        'I understand your sense of order, but this is how we feel more comfortable in our home.',
    'boundary': 'Evimizin düzeniyle ilgili kararı biz vermek istiyoruz.',
    'boundaryEn': 'We want to decide the order of our own home ourselves.',
    'calm':
        'Bu konuda farklı düşünüyoruz ama bunu tartışmaya çevirmek istemiyorum.',
    'calmEn':
        'We think differently about this, but I do not want it to turn into an argument.',
  },
  {
    'situation': 'Seni başka gelinlerle kıyaslıyor',
    'situationEn': 'She compares you with other brides',
    'soft':
        'Herkesin evi ve hayat düzeni farklı. Ben de elimden geleni yapıyorum.',
    'softEn': 'Every home and lifestyle is different. I am doing my best.',
    'boundary': 'Kıyaslanmak beni kırıyor. Bunu duymamayı tercih ederim.',
    'boundaryEn': 'Being compared hurts me. I would prefer not to hear this.',
    'calm':
        'Bu konuyu kıyaslama üzerinden değil, anlayışla konuşursak daha iyi olur.',
    'calmEn':
        'It would be better if we discussed this with understanding rather than comparison.',
  },
  {
    'situation': 'Habersiz eve geliyor',
    'situationEn': 'She comes home without notice',
    'soft': 'Sizi görmek güzel, fakat ev düzenimizi planlamamız gerekiyor.',
    'softEn': 'It is nice to see you, but we need to plan our home routine.',
    'boundary': 'Gelmeden önce haber verirseniz daha rahat oluruz.',
    'boundaryEn':
        'We would feel more comfortable if you let us know before coming.',
    'calm':
        'Önceden haberleşirsek hem sizi daha iyi ağırlarım hem de herkes rahat eder.',
    'calmEn':
        'If we communicate beforehand, I can welcome you better and everyone will feel more comfortable.',
  },
  {
    'situation': 'Eşini sana karşı etkiliyor',
    'situationEn': 'She influences your spouse against you',
    'soft': 'Farklı düşüncelerin olması normal, bunu anlayabiliyorum.',
    'softEn':
        'It is normal to have different opinions, and I can understand that.',
    'boundary':
        'Evliliğimizle ilgili kararları eşimle birlikte vermemiz gerekiyor.',
    'boundaryEn':
        'Decisions about our marriage need to be made by my spouse and me together.',
    'calm': 'Yanlış anlaşılmaları büyütmeden konuşarak çözebiliriz.',
    'calmEn': 'We can solve misunderstandings by talking before they grow.',
  },
  {
    'situation': 'Sürekli öğüt veriyor',
    'situationEn': 'She constantly gives advice',
    'soft': 'Tecrübelerinizi önemsiyorum ve iyi niyetinizi görüyorum.',
    'softEn': 'I value your experience and I see your good intentions.',
    'boundary': 'Bazı kararları deneyerek kendimiz öğrenmek istiyoruz.',
    'boundaryEn': 'We want to learn some decisions through our own experience.',
    'calm':
        'Fikrinizi alırım, ama son kararı kendi ev düzenimize göre veririz.',
    'calmEn':
        'I can listen to your opinion, but we will make the final decision according to our own home routine.',
  },
  {
    'situation': 'Yemeklerini eleştiriyor',
    'situationEn': 'She criticizes your cooking',
    'soft': 'Herkesin damak tadı farklı olabilir.',
    'softEn': 'Everyone can have different tastes.',
    'boundary': 'Yemek konusunda sürekli eleştirilmek beni üzüyor.',
    'boundaryEn': 'Being constantly criticized about food upsets me.',
    'calm': 'İsterseniz sevdiğiniz bir tarifi birlikte deneyebiliriz.',
    'calmEn': 'If you like, we can try a recipe you enjoy together.',
  },
  {
    'situation': 'Torun konusunda baskı yapıyor',
    'situationEn': 'She puts pressure about the grandchild',
    'soft': 'Torununuzu sevdiğinizi biliyorum.',
    'softEn': 'I know you love your grandchild.',
    'boundary': 'Çocuğumuzla ilgili kararları anne-baba olarak biz vermeliyiz.',
    'boundaryEn': 'As parents, we need to make decisions about our child.',
    'calm':
        'Sizin sevginizi koruyarak bizim ebeveynlik düzenimize de saygı duyulmasını isteriz.',
    'calmEn':
        'We want your love to remain, while also having our parenting routine respected.',
  },
  {
    'situation': 'Maddi konulara karışıyor',
    'situationEn': 'She interferes in financial matters',
    'soft': 'Bizi düşündüğünüzü biliyorum.',
    'softEn': 'I know you are thinking of us.',
    'boundary':
        'Maddi kararlarımızı eşimle birlikte kendimiz vermek istiyoruz.',
    'boundaryEn':
        'We want to make our financial decisions ourselves as a couple.',
    'calm': 'Bu konuda kendi planımız var, gerektiğinde fikrinizi alırız.',
    'calmEn':
        'We have our own plan on this issue, and we will ask for your opinion when needed.',
  },
  {
    'situation': 'Evin temizliğini eleştiriyor',
    'situationEn': 'She criticizes the cleanliness of the home',
    'soft': 'Temizlik konusunda hassas olduğunuzu biliyorum.',
    'softEn': 'I know you are sensitive about cleanliness.',
    'boundary':
        'Kendi evimizin düzenini kendi şartlarımıza göre kurmak istiyoruz.',
    'boundaryEn':
        'We want to arrange our own home according to our own conditions.',
    'calm': 'Herkesin ev düzeni farklı olabilir, bunu anlayışla karşılayalım.',
    'calmEn':
        'Everyone’s home routine can be different. Let’s approach this with understanding.',
  },
  {
    'situation': 'Eşine sürekli şikayet ediyor',
    'situationEn': 'She constantly complains about you to your spouse',
    'soft': 'Bir sorun varsa doğrudan konuşmayı tercih ederim.',
    'softEn': 'If there is a problem, I would prefer to talk directly.',
    'boundary': 'Hakkımda eşime şikayet edilmesi beni yıpratıyor.',
    'boundaryEn': 'Complaints about me to my spouse wear me down.',
    'calm': 'Konuyu araya başkalarını sokmadan konuşursak daha kolay çözeriz.',
    'calmEn':
        'We can solve the issue more easily if we talk without involving others.',
  },
];

const List<Map<String, String>> gelinAnswers = [
  {
    'situation': 'Yeni ailede kabul görmüyorsun gibi hissediyorsun',
    'situationEn': 'You feel like you are not accepted in the new family',
    'soft':
        'Aileye uyum sağlamaya çalışıyorum, bunun zamanla daha iyi olacağına inanıyorum.',
    'softEn':
        'I am trying to adapt to the family, and I believe this will get better over time.',
    'boundary': 'Kabul görmek için kendimden vazgeçmek istemiyorum.',
    'boundaryEn': 'I do not want to give up myself just to be accepted.',
    'calm': 'Birbirimizi zamanla daha iyi tanıyacağımızı düşünüyorum.',
    'calmEn': 'I think we will understand each other better over time.',
  },
  {
    'situation': 'Gelin olarak sürekli beklenti altındasın',
    'situationEn': 'You are constantly under expectations as a bride',
    'soft':
        'Elimden geleni yapıyorum ama her beklentiyi aynı anda karşılamam mümkün olmayabilir.',
    'softEn':
        'I am doing my best, but I may not be able to meet every expectation at once.',
    'boundary':
        'Benden beklentiler konuşulabilir ama baskı altında kalmak istemiyorum.',
    'boundaryEn':
        'Expectations from me can be discussed, but I do not want to feel pressured.',
    'calm': 'Bunu daha sakin ve açık konuşursak orta yol bulabiliriz.',
    'calmEn':
        'If we talk about this calmly and openly, we can find a middle ground.',
  },
  {
    'situation': 'Eşinin ailesiyle sınır koymakta zorlanıyorsun',
    'situationEn': 'You struggle to set boundaries with your spouse’s family',
    'soft':
        'Aile bağlarını önemsiyorum ama bizim de özel alanımızın olması gerekiyor.',
    'softEn': 'I value family bonds, but we also need our own private space.',
    'boundary':
        'Bazı kararları eşimle birlikte, kendi evimiz içinde almak istiyorum.',
    'boundaryEn':
        'I want to make some decisions with my spouse within our own home.',
    'calm': 'Hem aileyle iyi olmak hem de evimizin sınırlarını korumak mümkün.',
    'calmEn':
        'It is possible to have a good relationship with the family while protecting our home boundaries.',
  },
  {
    'situation': 'Aile içinde sürekli hizmet bekleniyor',
    'situationEn': 'Constant service is expected from you in the family',
    'soft': 'Misafire ve aileye önem veriyorum.',
    'softEn': 'I care about guests and family.',
    'boundary': 'Ama her sorumluluğun sadece bana yüklenmesini istemiyorum.',
    'boundaryEn':
        'But I do not want every responsibility to be placed only on me.',
    'calm': 'İşleri paylaşarak yaparsak herkes daha rahat eder.',
    'calmEn': 'If we share the work, everyone will feel more comfortable.',
  },
  {
    'situation': 'Kendi tarzın eleştiriliyor',
    'situationEn': 'Your personal style is criticized',
    'soft': 'Sizin alışık olduğunuz düzen farklı olabilir.',
    'softEn': 'The routine you are used to may be different.',
    'boundary': 'Kendi tarzıma ve seçimlerime saygı duyulmasını isterim.',
    'boundaryEn': 'I would like my style and choices to be respected.',
    'calm': 'Farklılıklarımızla da iyi geçinebiliriz.',
    'calmEn': 'We can still get along well with our differences.',
  },
  {
    'situation': 'Aile toplantılarında dışlanmış hissediyorsun',
    'situationEn': 'You feel excluded at family gatherings',
    'soft': 'Aileye daha rahat dahil olmak isterim.',
    'softEn': 'I would like to feel more included in the family.',
    'boundary': 'Yok sayıldığımı hissettiğimde kırılıyorum.',
    'boundaryEn': 'I feel hurt when I feel ignored.',
    'calm': 'Beni de konuşmalara dahil ederseniz daha iyi hissederim.',
    'calmEn': 'I would feel better if you included me in conversations too.',
  },
];

const List<Map<String, String>> gorumceAnswers = [
  {
    'situation': 'Özel bilgilerini aile içinde paylaşıyor',
    'situationEn': 'She shares your private information within the family',
    'soft': 'Bunu paylaştığında kendimi rahatsız hissediyorum.',
    'softEn': 'I feel uncomfortable when you share this.',
    'boundary': 'Özel konularımın başkalarıyla konuşulmasını istemiyorum.',
    'boundaryEn': 'I do not want my private matters discussed with others.',
    'calm': 'Bundan sonra özel konuları aramızda tutarsak daha rahat olurum.',
    'calmEn':
        'I would feel more comfortable if we kept private matters between us from now on.',
  },
  {
    'situation': 'Eşinle arana giriyor gibi hissediyorsun',
    'situationEn': 'You feel like she is coming between you and your spouse',
    'soft':
        'Kardeşlik bağınızı anlıyorum ama evliliğimizle ilgili konuları eşimle çözmek isterim.',
    'softEn':
        'I understand your sibling bond, but I want to solve issues about my marriage with my spouse.',
    'boundary':
        'Evliliğimizle ilgili kararları eşimle birlikte almamız gerekiyor.',
    'boundaryEn':
        'Decisions about our marriage need to be made by my spouse and me together.',
    'calm': 'Herkesin yeri ayrı; bu dengeyi korursak daha huzurlu olur.',
    'calmEn':
        'Everyone has a separate place. If we protect this balance, things will be more peaceful.',
  },
  {
    'situation': 'Kıyaslama ve rekabet hissi var',
    'situationEn': 'There is a feeling of comparison and competition',
    'soft': 'Ben rekabet etmek istemiyorum; herkesin hayatı farklı.',
    'softEn': 'I do not want to compete; everyone’s life is different.',
    'boundary': 'Kıyaslandığımda kendimi rahatsız hissediyorum.',
    'boundaryEn': 'I feel uncomfortable when I am compared.',
    'calm': 'Birbirimizi kıyaslamak yerine desteklemek daha iyi olur.',
    'calmEn':
        'It would be better to support each other instead of comparing each other.',
  },
  {
    'situation': 'Seni sürekli eleştiriyor',
    'situationEn': 'She constantly criticizes you',
    'soft': 'Fikirlerini anlıyorum ama herkesin yaklaşımı farklı olabilir.',
    'softEn':
        'I understand your opinions, but everyone’s approach can be different.',
    'boundary': 'Sürekli eleştirilmek beni rahatsız ediyor.',
    'boundaryEn': 'Being constantly criticized makes me uncomfortable.',
    'calm': 'Farklı düşünsek de birbirimize saygı duyabiliriz.',
    'calmEn': 'Even if we think differently, we can respect each other.',
  },
  {
    'situation': 'Özel hayatınla ilgili çok soru soruyor',
    'situationEn': 'She asks too many questions about your private life',
    'soft': 'Merak ettiğini biliyorum.',
    'softEn': 'I know you are curious.',
    'boundary': 'Bazı konuların özel kalmasını tercih ediyorum.',
    'boundaryEn': 'I prefer some matters to remain private.',
    'calm': 'Başka konulardan konuşabiliriz.',
    'calmEn': 'We can talk about other topics.',
  },
  {
    'situation': 'Seni aileye şikayet ediyor',
    'situationEn': 'She complains about you to the family',
    'soft': 'Bir sorun varsa benimle konuşabilirsin.',
    'softEn': 'If there is a problem, you can talk to me.',
    'boundary': 'Hakkımda başkalarına konuşulmasını istemiyorum.',
    'boundaryEn': 'I do not want others to talk about me behind my back.',
    'calm': 'Sorunları aramızda çözmek daha doğru olur.',
    'calmEn': 'It would be better to solve problems between us.',
  },
  {
    'situation': 'Çocuklarını senin çocuklarınla kıyaslıyor',
    'situationEn': 'She compares her children with your children',
    'soft': 'Her çocuğun gelişimi farklıdır.',
    'softEn': 'Every child develops differently.',
    'boundary': 'Çocukların kıyaslanmasını istemiyorum.',
    'boundaryEn': 'I do not want the children to be compared.',
    'calm': 'Her çocuğun güçlü yönleri farklıdır.',
    'calmEn': 'Every child has different strengths.',
  },
  {
    'situation': 'Maddi durumunuzu sorguluyor',
    'situationEn': 'She questions your financial situation',
    'soft': 'Herkesin şartları farklı.',
    'softEn': 'Everyone’s conditions are different.',
    'boundary': 'Maddi konularımız özel kalmalı.',
    'boundaryEn': 'Our financial matters should remain private.',
    'calm': 'Bu konuyu konuşmamayı tercih ederim.',
    'calmEn': 'I prefer not to discuss this topic.',
  },
  {
    'situation': 'Sürekli tavsiye veriyor',
    'situationEn': 'She constantly gives advice',
    'soft': 'Düşündüğün için teşekkür ederim.',
    'softEn': 'Thank you for thinking of me.',
    'boundary': 'Bazı kararları kendim vermek istiyorum.',
    'boundaryEn': 'I want to make some decisions myself.',
    'calm': 'Fikrini değerlendireceğim.',
    'calmEn': 'I will consider your opinion.',
  },
  {
    'situation': 'Bayramlarda ve ziyaretlerde sorun çıkarıyor',
    'situationEn': 'She causes problems during holidays and visits',
    'soft': 'Herkesin beklentisi farklı olabilir.',
    'softEn': 'Everyone may have different expectations.',
    'boundary': 'Bana baskı yapılmasını istemiyorum.',
    'boundaryEn': 'I do not want to be pressured.',
    'calm': 'Orta yolu bulabiliriz.',
    'calmEn': 'We can find a middle ground.',
  },
];

const List<Map<String, String>> eltiAnswers = [
  {
    'situation': 'Çocuklar üzerinden kıyaslama yapılıyor',
    'situationEn': 'Comparison is made through children',
    'soft':
        'Her çocuğun gelişimi ve karakteri farklı, kıyaslamak doğru olmayabilir.',
    'softEn':
        'Every child’s development and character are different; comparing them may not be right.',
    'boundary': 'Çocuklar üzerinden kıyaslama yapılmasını istemiyorum.',
    'boundaryEn': 'I do not want comparisons to be made through children.',
    'calm':
        'Çocukları yarıştırmak yerine onların iyi taraflarını destekleyelim.',
    'calmEn':
        'Instead of making children compete, let’s support their strengths.',
  },
  {
    'situation': 'Aile büyüklerine yakınlık yarışı var',
    'situationEn': 'There is competition for closeness to family elders',
    'soft':
        'Herkesin aileyle ilişkisi farklı olabilir, bunu yarış gibi görmemek daha iyi.',
    'softEn':
        'Everyone’s relationship with family can be different; it is better not to see it as a competition.',
    'boundary': 'Aile içindeki yakınlığı rekabete çevirmek istemiyorum.',
    'boundaryEn':
        'I do not want closeness within the family to become competition.',
    'calm':
        'Herkes kendi samimiyetiyle ilişkisini sürdürürse daha huzurlu olur.',
    'calmEn':
        'It will be more peaceful if everyone maintains relationships sincerely in their own way.',
  },
  {
    'situation': 'Maddi kıyaslama yapılıyor',
    'situationEn': 'Financial comparison is being made',
    'soft':
        'Herkesin imkânı ve düzeni farklı. Bunu kıyaslamak bizi gereksiz yorar.',
    'softEn':
        'Everyone’s means and routine are different. Comparing this only tires us unnecessarily.',
    'boundary': 'Maddi konular üzerinden kıyaslanmak istemiyorum.',
    'boundaryEn': 'I do not want to be compared through financial matters.',
    'calm': 'Bu konuları karşılaştırmadan konuşursak daha sağlıklı olur.',
    'calmEn':
        'It would be healthier if we talked about these matters without comparison.',
  },
  {
    'situation': 'Aile içinde dedikodu yapıyor',
    'situationEn': 'She gossips within the family',
    'soft': 'Yanlış anlaşılma olmasını istemem.',
    'softEn': 'I do not want misunderstandings to happen.',
    'boundary': 'Hakkımda konuşulmasını istemiyorum.',
    'boundaryEn': 'I do not want people talking about me behind my back.',
    'calm': 'Sorun varsa doğrudan konuşabiliriz.',
    'calmEn': 'If there is a problem, we can talk directly.',
  },
  {
    'situation': 'Sürekli rekabet oluşturuyor',
    'situationEn': 'She constantly creates competition',
    'soft': 'Ben ilişkimizi yarış gibi görmek istemiyorum.',
    'softEn': 'I do not want to see our relationship as a competition.',
    'boundary': 'Rekabet dili beni rahatsız ediyor.',
    'boundaryEn': 'Competitive language makes me uncomfortable.',
    'calm': 'Birbirimizi geçmeye değil, huzurlu kalmaya odaklanalım.',
    'calmEn':
        'Let’s focus on staying peaceful, not trying to outdo each other.',
  },
  {
    'situation': 'Kayınvalideye yakınlık yarışı yapıyor',
    'situationEn': 'She competes for closeness to the mother-in-law',
    'soft': 'Herkesin aile büyükleriyle bağı farklı olabilir.',
    'softEn': 'Everyone’s bond with family elders can be different.',
    'boundary': 'Yakınlığı yarışa çevirmek istemiyorum.',
    'boundaryEn': 'I do not want closeness to turn into competition.',
    'calm': 'Herkes kendi samimiyetiyle ilişkisini sürdürebilir.',
    'calmEn':
        'Everyone can continue their relationship with their own sincerity.',
  },
  {
    'situation': 'Senin yaptıklarını küçümsüyor',
    'situationEn': 'She belittles what you do',
    'soft': 'Farklı düşünmen normal.',
    'softEn': 'It is normal for you to think differently.',
    'boundary': 'Emeklerimin küçümsenmesini istemiyorum.',
    'boundaryEn': 'I do not want my efforts to be belittled.',
    'calm': 'Birbirimizin emeğine saygı gösterirsek daha iyi olur.',
    'calmEn': 'It would be better if we respected each other’s efforts.',
  },
];

const List<Map<String, String>> cocukAnswers = [
  {
    'situation': 'Çocuk ekranı bırakmak istemiyor',
    'situationEn': 'The child does not want to stop screen time',
    'soft': 'Ekranı sevdiğini biliyorum. Ama şimdi mola zamanı.',
    'softEn': 'I know you like the screen. But now it is break time.',
    'boundary': 'Ekran süresi bitti. Şimdi başka bir şeye geçiyoruz.',
    'boundaryEn':
        'Screen time is over. Now we are moving on to something else.',
    'calm': 'İstersen birlikte başka bir etkinlik seçebiliriz.',
    'calmEn': 'If you want, we can choose another activity together.',
  },
  {
    'situation': 'Çocuk öfke patlaması yaşıyor',
    'situationEn': 'The child is having an anger outburst',
    'soft': 'Şu an çok öfkelendiğini görüyorum. Yanındayım.',
    'softEn':
        'I can see that you are very angry right now. I am here with you.',
    'boundary': 'Öfkeli olabilirsin ama vurmak ya da bağırmak doğru değil.',
    'boundaryEn': 'You can be angry, but hitting or shouting is not okay.',
    'calm': 'Sakinleşince ne olduğunu birlikte konuşacağız.',
    'calmEn': 'When you calm down, we will talk about what happened together.',
  },
  {
    'situation': 'Çocuk söz dinlemiyor',
    'situationEn': 'The child does not listen',
    'soft': 'Bunu yapmak istemediğini anlıyorum.',
    'softEn': 'I understand that you do not want to do this.',
    'boundary':
        'Ama bu kural değişmeyecek. Önce bunu yapacağız, sonra istediğin şeye geçebiliriz.',
    'boundaryEn':
        'But this rule will not change. First we will do this, then we can move to what you want.',
    'calm':
        'Seçenek sunayım: önce bunu mu yapmak istersin, yoksa beş dakika sonra mı?',
    'calmEn':
        'Let me give you a choice: do you want to do it now or in five minutes?',
  },
  {
    'situation': 'Ders çalışmak istemiyor',
    'situationEn': 'The child does not want to study',
    'soft': 'Şu an canın istemiyor olabilir.',
    'softEn': 'You may not feel like doing it right now.',
    'boundary': 'Ama sorumluluklarını yerine getirmen gerekiyor.',
    'boundaryEn': 'But you need to fulfill your responsibilities.',
    'calm': 'Kısa bir plan yapalım ve küçük bir adımla başlayalım.',
    'calmEn': 'Let’s make a short plan and start with a small step.',
  },
  {
    'situation': 'Kardeşini kıskanıyor',
    'situationEn': 'The child is jealous of their sibling',
    'soft': 'Kendini dışlanmış hissediyor olabilirsin.',
    'softEn': 'You may be feeling left out.',
    'boundary': 'Kardeşine zarar vermene izin veremem.',
    'boundaryEn': 'I cannot allow you to hurt your sibling.',
    'calm': 'Senin için de özel zaman ayıracağım.',
    'calmEn': 'I will also make special time for you.',
  },
  {
    'situation': 'Yalan söylüyor',
    'situationEn': 'The child is lying',
    'soft': 'Doğruyu söylemek zor gelmiş olabilir.',
    'softEn': 'Telling the truth may have felt difficult.',
    'boundary': 'Yalan söylemek doğru değil.',
    'boundaryEn': 'Lying is not right.',
    'calm': 'Doğruyu söylersen birlikte çözüm bulabiliriz.',
    'calmEn': 'If you tell the truth, we can find a solution together.',
  },
  {
    'situation': 'Sorumluluk almak istemiyor',
    'situationEn': 'The child does not want to take responsibility',
    'soft': 'Bazen görevler sıkıcı gelebilir.',
    'softEn': 'Sometimes tasks can feel boring.',
    'boundary': 'Ama herkesin evde sorumluluğu var.',
    'boundaryEn': 'But everyone has responsibilities at home.',
    'calm': 'İstersen görevini küçük parçalara bölelim.',
    'calmEn': 'If you want, we can divide your task into smaller parts.',
  },
  {
    'situation': 'Sürekli pazarlık yapıyor',
    'situationEn': 'The child constantly bargains',
    'soft': 'İsteğini anlıyorum.',
    'softEn': 'I understand what you want.',
    'boundary': 'Bu karar değişmeyecek.',
    'boundaryEn': 'This decision will not change.',
    'calm': 'İki seçenek sunuyorum; hangisini seçmek istersin?',
    'calmEn':
        'I am giving you two options; which one would you like to choose?',
  },
];

const List<Map<String, String>> esAnswers = [
  {
    'situation': 'Eşin seni dinlemiyor gibi geliyor',
    'situationEn': 'You feel like your spouse does not listen to you',
    'soft': 'Seninle konuşurken gerçekten duyulmak istiyorum.',
    'softEn': 'When I talk to you, I truly want to feel heard.',
    'boundary': 'Konuşurken sözüm kesildiğinde kendimi değersiz hissediyorum.',
    'boundaryEn': 'When I am interrupted while speaking, I feel unvalued.',
    'calm': 'Beni birkaç dakika dinlersen sonra seni de dinlemek isterim.',
    'calmEn':
        'If you listen to me for a few minutes, I would like to listen to you too.',
  },
  {
    'situation': 'Eşinin ailesi evliliğinize çok karışıyor',
    'situationEn': 'Your spouse’s family interferes too much in your marriage',
    'soft':
        'Aileni önemsediğini biliyorum, ama bizim de kendi sınırlarımız olmalı.',
    'softEn':
        'I know you care about your family, but we also need our own boundaries.',
    'boundary': 'Evliliğimizle ilgili kararları önce ikimiz konuşmalıyız.',
    'boundaryEn':
        'We should discuss decisions about our marriage between the two of us first.',
    'calm': 'Aileni kırmadan ama evimizi de koruyarak denge kurabiliriz.',
    'calmEn':
        'We can find balance without hurting your family while still protecting our home.',
  },
  {
    'situation': 'Ev işleri tek kişiye kalıyor',
    'situationEn': 'Housework falls on one person',
    'soft': 'Ev işleri konusunda yorulduğumu hissediyorum.',
    'softEn': 'I feel tired about the housework.',
    'boundary': 'Bu sorumluluğun sadece bana kalmasını istemiyorum.',
    'boundaryEn': 'I do not want this responsibility to fall only on me.',
    'calm': 'Birlikte görevleri bölüşürsek ikimiz de daha rahat ederiz.',
    'calmEn': 'If we share the tasks, both of us will feel more comfortable.',
  },
  {
    'situation': 'Duygusal olarak uzak davranıyor',
    'situationEn': 'Your spouse acts emotionally distant',
    'soft': 'Son zamanlarda aramızda mesafe hissediyorum.',
    'softEn': 'Lately, I feel distance between us.',
    'boundary':
        'Duygusal ihtiyaçlarımın tamamen görmezden gelinmesini istemiyorum.',
    'boundaryEn': 'I do not want my emotional needs to be completely ignored.',
    'calm': 'Küçük de olsa birlikte zaman ayırabiliriz.',
    'calmEn': 'Even if it is small, we can spend some time together.',
  },
  {
    'situation': 'Para konularında anlaşamıyorsunuz',
    'situationEn': 'You cannot agree on money matters',
    'soft': 'Bu konuda ikimiz de kaygılanıyor olabiliriz.',
    'softEn': 'Both of us may be worried about this issue.',
    'boundary': 'Maddi kararları tek taraflı almak istemiyorum.',
    'boundaryEn': 'I do not want financial decisions to be made one-sidedly.',
    'calm': 'Birlikte açık bir plan yaparsak daha huzurlu oluruz.',
    'calmEn': 'If we make a clear plan together, we will feel more peaceful.',
  },
];

const List<Map<String, String>> genelAnswers = [
  {
    'situation': 'Kırıldığında ne söyleyebilirsin?',
    'situationEn': 'What can you say when you feel hurt?',
    'soft': 'Bu söz beni kırdı, bunu sakin şekilde konuşmak isterim.',
    'softEn':
        'That sentence hurt me, and I would like to talk about it calmly.',
    'boundary': 'Benimle bu şekilde konuşulmasını istemiyorum.',
    'boundaryEn': 'I do not want to be spoken to in this way.',
    'calm': 'Şu an tartışmak yerine biraz sakinleşip sonra konuşalım.',
    'calmEn':
        'Instead of arguing now, let’s calm down a little and talk later.',
  },
];
