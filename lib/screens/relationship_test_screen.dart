import 'package:flutter/material.dart';
import 'emotion_detail_screen.dart';

class RelationshipTestScreen extends StatefulWidget {
  final String categoryTitle;
  final String languageCode;

  const RelationshipTestScreen({
    super.key,
    required this.categoryTitle,
    required this.languageCode,
  });

  @override
  State<RelationshipTestScreen> createState() => _RelationshipTestScreenState();
}

class _RelationshipTestScreenState extends State<RelationshipTestScreen> {
  int currentQuestion = 0;
  int score = 0;

  bool get isEn => widget.languageCode == 'en';

  String t(String tr, String en) => isEn ? en : tr;

  String get categoryType {
    final title = widget.categoryTitle.toLowerCase();

    if (title.contains('eş') ||
        title.contains('spouse') ||
        title.contains('partner')) {
      return 'spouse';
    } else if (title.contains('gelin') || title.contains('bride')) {
      return 'bride';
    } else if (title.contains('kaynana') ||
        title.contains('kaynan') ||
        title.contains('mother-in-law')) {
      return 'motherInLaw';
    } else if (title.contains('görümce') || title.contains('sister-in-law')) {
      return 'sisterInLaw';
    } else if (title.contains('elti') || title.contains('co-sister')) {
      return 'coSisterInLaw';
    } else if (title.contains('çocuk') || title.contains('children')) {
      return 'children';
    } else {
      return 'family';
    }
  }

  List<Map<String, dynamic>> getQuestions() {
    final lang = widget.languageCode;

    switch (categoryType) {
      case 'spouse':
        return lang == 'en' ? spouseQuestionsEn : spouseQuestionsTr;
      case 'bride':
        return lang == 'en' ? brideQuestionsEn : brideQuestionsTr;
      case 'motherInLaw':
        return lang == 'en' ? motherInLawQuestionsEn : motherInLawQuestionsTr;
      case 'sisterInLaw':
        return lang == 'en' ? sisterInLawQuestionsEn : sisterInLawQuestionsTr;
      case 'coSisterInLaw':
        return lang == 'en'
            ? coSisterInLawQuestionsEn
            : coSisterInLawQuestionsTr;
      case 'children':
        return lang == 'en' ? childrenQuestionsEn : childrenQuestionsTr;
      default:
        return lang == 'en' ? familyQuestionsEn : familyQuestionsTr;
    }
  }

  void answerQuestion(int point) {
    score += point;
    final questions = getQuestions();

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      showResult();
    }
  }

  void openAiSupport({String? extraText}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmotionDetailScreen(
          title: widget.categoryTitle,
          icon: '🤖',
          message: extraText ??
              t(
                'Bu konuyu biraz daha detaylı anlatmak istersen buraya yaz. AI sana sakin, destekleyici ve uygulanabilir öneriler sunsun.',
                'If you would like to explain this situation in more detail, write below. Let AI provide calm, supportive and practical suggestions.',
              ),
          languageCode: widget.languageCode,
        ),
      ),
    );
  }

  Map<String, String> resultText(double percentage) {
    if (categoryType == 'spouse') {
      if (percentage >= 0.75) {
        return {
          'title': t('Güçlü Evlilik Bağı', 'Strong Marriage Bond'),
          'message': t(
            'Bu ilişkide dinleme, güven ve ortak karar alma güçlü görünüyor. Bu bağı korumak için küçük ama düzenli iletişim alışkanlıklarını sürdürmelisiniz.',
            'Listening, trust, and shared decision-making seem strong in this relationship. To protect this bond, continue small but regular communication habits.',
          ),
        };
      } else if (percentage >= 0.50) {
        return {
          'title': t('İletişim Geliştirilebilir', 'Communication Can Improve'),
          'message': t(
            'Evlilikte bazı konular konuşuluyor ama bazı ihtiyaçlar bastırılıyor olabilir. Özellikle aile sınırları, ev sorumlulukları ve duygusal destek konularında daha açık konuşmak faydalı olabilir.',
            'Some topics are being discussed, but some needs may be suppressed. It may help to speak more openly about family boundaries, household responsibilities, and emotional support.',
          ),
        };
      } else {
        return {
          'title': t('Duygusal Uzaklaşma Riski', 'Risk of Emotional Distance'),
          'message': t(
            'Bu ilişkide duyulmama, yalnız kalma veya destek eksikliği hissi olabilir. Tartışmayı büyütmeden “ben böyle hissediyorum” diliyle konuşmak ve gerekirse destek almak önemli olabilir.',
            'There may be feelings of not being heard, loneliness, or lack of support. It may be important to use “I feel this way” language and seek support if needed.',
          ),
        };
      }
    }

    if (categoryType == 'bride') {
      if (percentage >= 0.75) {
        return {
          'title':
              t('Uyum Sağlayan Gelin Dengesi', 'Balanced Bride Adjustment'),
          'message': t(
            'Yeni aileyle ilişkinde sınır ve uyum dengesi iyi görünüyor. Kendi kimliğini korurken aileye dahil olabilmen güçlü bir işaret.',
            'Your balance between boundaries and harmony with the new family seems healthy. Being included while protecting your own identity is a strong sign.',
          ),
        };
      } else if (percentage >= 0.50) {
        return {
          'title': t('Beklenti Baskısı', 'Pressure of Expectations'),
          'message': t(
            'Gelin olarak senden fazla uyum, hizmet veya sessizlik bekleniyor olabilir. Kırmadan ama net şekilde sınır koyman ilişkiyi daha sağlıklı hale getirebilir.',
            'As a bride, too much adaptation, service, or silence may be expected from you. Setting clear but respectful boundaries can make the relationship healthier.',
          ),
        };
      } else {
        return {
          'title': t('Yoğun Baskı ve Kabul Görmeme',
              'High Pressure and Lack of Acceptance'),
          'message': t(
            'Bu ilişkide kabul görmeme, kıyaslanma veya sürekli beklenti altında kalma hissi yüksek olabilir. Eşinle ortak sınır belirlemek önemli görünüyor.',
            'There may be strong feelings of not being accepted, being compared, or constantly being under expectations. Setting shared boundaries with your spouse seems important.',
          ),
        };
      }
    }

    if (categoryType == 'motherInLaw') {
      if (percentage >= 0.75) {
        return {
          'title': t('Sağlıklı Sınırlar', 'Healthy Boundaries'),
          'message': t(
            'Kayınvalidenle ilişkide saygı ve mesafe dengesi iyi görünüyor. Bu dengeyi korumak için açık ama sakin iletişim yeterli olabilir.',
            'Respect and distance seem well balanced in your relationship with your mother-in-law. Calm and clear communication may be enough to protect this balance.',
          ),
        };
      } else if (percentage >= 0.50) {
        return {
          'title': t('Müdahale Eğilimi', 'Tendency to Interfere'),
          'message': t(
            'Özel hayat, ev düzeni veya çocuk yetiştirme konularında zaman zaman müdahale olabilir. Sınırları erken ve sakin şekilde ifade etmek faydalı olur.',
            'There may sometimes be interference in private life, home order, or parenting decisions. Expressing boundaries early and calmly can help.',
          ),
        };
      } else {
        return {
          'title': t('Yoğun Sınır İhlali', 'Serious Boundary Violations'),
          'message': t(
            'Kayınvalide ilişkisinde eleştiri, kıyaslama veya özel hayata müdahale seni yoruyor olabilir. Eş desteğiyle birlikte net sınırlar koymak önemli.',
            'Criticism, comparison, or interference in private life may be exhausting you. Setting clear boundaries with your spouse’s support is important.',
          ),
        };
      }
    }

    if (categoryType == 'sisterInLaw') {
      if (percentage >= 0.75) {
        return {
          'title': t('Dengeli Görümce İlişkisi',
              'Balanced Sister-in-law Relationship'),
          'message': t(
            'Görümcenle ilişkide güven ve mesafe dengesi iyi görünüyor. Özel alan korunursa ilişki daha da rahat ilerleyebilir.',
            'Trust and distance seem balanced in this relationship. If personal boundaries are protected, the relationship can progress more comfortably.',
          ),
        };
      } else if (percentage >= 0.50) {
        return {
          'title': t('Rekabet ve Kıyaslama Riski',
              'Risk of Competition and Comparison'),
          'message': t(
            'Aranızda zaman zaman kıyaslama, yorum yapma veya aile içinde taraf tutma olabilir. Özel bilgileri sınırlı paylaşmak ve sakin mesafe korumak iyi olur.',
            'There may sometimes be comparison, comments, or taking sides within the family. Sharing private information less and keeping calm distance may help.',
          ),
        };
      } else {
        return {
          'title': t('Güven Sorunu ve Çatışma', 'Trust Issues and Conflict'),
          'message': t(
            'Bu ilişkide özel bilgilerin paylaşılması, eşinle arana girme veya sürekli eleştiri seni yıpratıyor olabilir. Mesafeli ama saygılı sınır en sağlıklı yol olabilir.',
            'Sharing private information, interfering between you and your spouse, or constant criticism may be wearing you down. A respectful but distant boundary may be healthiest.',
          ),
        };
      }
    }

    if (categoryType == 'coSisterInLaw') {
      if (percentage >= 0.75) {
        return {
          'title': t('İş Birliği ve Saygılı Mesafe',
              'Cooperation and Respectful Distance'),
          'message': t(
            'Elti ilişkinizde rekabetten çok saygılı mesafe ve iş birliği görünüyor. Bu denge aile ortamını rahatlatır.',
            'Your relationship seems to have more respectful distance and cooperation than competition. This balance can ease the family atmosphere.',
          ),
        };
      } else if (percentage >= 0.50) {
        return {
          'title': t('Kıyaslama Baskısı', 'Pressure of Comparison'),
          'message': t(
            'Çocuk, maddi durum veya aile büyüklerine yakınlık konusunda kıyaslama hissi olabilir. Yarışa girmeden kendi düzenini korumak daha sağlıklı olur.',
            'There may be comparison around children, finances, or closeness to elders. Protecting your own order without entering competition is healthier.',
          ),
        };
      } else {
        return {
          'title':
              t('Yıpratıcı Rekabet Döngüsü', 'Exhausting Competition Cycle'),
          'message': t(
            'Bu ilişkide rekabet, dedikodu veya aile içinde görünmez yarış baskısı yüksek olabilir. Kişisel bilgileri sınırlamak ve kıyaslamaya cevap vermemek iyi olur.',
            'Competition, gossip, or invisible family rivalry may be strong in this relationship. Limiting personal information and not responding to comparisons may help.',
          ),
        };
      }
    }

    if (categoryType == 'children') {
      if (percentage >= 0.75) {
        return {
          'title': t('Güvenli Bağ', 'Secure Bond'),
          'message': t(
            'Çocuğunla iletişimde güven, sınır ve dinleme dengesi iyi görünüyor. Bu bağı korumak için düzenli kaliteli zaman çok değerli.',
            'Trust, boundaries, and listening seem well balanced in your communication with your child. Regular quality time is very valuable for protecting this bond.',
          ),
        };
      } else if (percentage >= 0.50) {
        return {
          'title': t('İletişim ve Sınır Dengesi Geliştirilebilir',
              'Communication and Boundaries Can Improve'),
          'message': t(
            'Çocuğunla iletişimde bazı alanlar iyi, bazı alanlarda tutarsızlık olabilir. Ekran, öfke ve sorumluluklarda net ama sevgi dolu sınırlar faydalı olur.',
            'Some areas of communication with your child are good, while some may be inconsistent. Clear but loving boundaries around screen time, anger, and responsibilities can help.',
          ),
        };
      } else {
        return {
          'title': t('Ebeveyn Yorgunluğu Riski', 'Risk of Parental Burnout'),
          'message': t(
            'Çocukla iletişimde öfke, ekran, söz dinlememe veya yorgunluk seni zorlayabilir. Daha kısa kurallar, sakin tekrarlar ve küçük kaliteli zamanlar işe yarayabilir.',
            'Anger, screen time, not listening, or fatigue may be making parenting difficult. Shorter rules, calm repetition, and small quality moments may help.',
          ),
        };
      }
    }

    if (percentage >= 0.75) {
      return {
        'title': t('Dengeli Aile Ortamı', 'Balanced Family Environment'),
        'message': t(
          'Ev içinde iletişim, sorumluluk ve huzur dengesi iyi görünüyor.',
          'Communication, responsibilities, and peace at home seem balanced.',
        ),
      };
    } else if (percentage >= 0.50) {
      return {
        'title':
            t('Geliştirilebilir Aile Dengesi', 'Family Balance Can Improve'),
        'message': t(
          'Ev içinde bazı sorumluluk ve iletişim alanlarında dengesizlik olabilir.',
          'There may be imbalance in some areas of responsibility and communication at home.',
        ),
      };
    } else {
      return {
        'title': t('Yüksek Gerilimli Ortam', 'High-Tension Environment'),
        'message': t(
          'Ev içinde tartışma, yorgunluk veya sorumluluk yükü yüksek görünüyor.',
          'Arguments, fatigue, or the burden of responsibilities may be high at home.',
        ),
      };
    }
  }

  void showResult() {
    final questions = getQuestions();
    final maxScore = questions.length * 3;
    final percentage = score / maxScore;
    final result = resultText(percentage);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(result['title']!),
        content: SingleChildScrollView(
          child: Text(
            '${t('Toplam puan', 'Total score')}: $score / $maxScore\n\n${result['message']}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAiSupport(
                extraText:
                    '${t('Test sonucu', 'Test result')}: ${result['title']}\n\n${result['message']}',
              );
            },
            child: Text(t('🤖 AI Destek Al', '🤖 Get AI Support')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestion = 0;
                score = 0;
              });
            },
            child: Text(t('Tekrar Dene', 'Try Again')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(t('Kapat', 'Close')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = getQuestions();
    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryTitle} ${t('Testi', 'Test')}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            onPressed: () => openAiSupport(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
            ),
            const SizedBox(height: 18),
            Text(
              '${t('Soru', 'Question')} ${currentQuestion + 1}/${questions.length}',
              style: const TextStyle(fontSize: 18, color: Colors.teal),
            ),
            const SizedBox(height: 24),
            Text(
              question['question'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.smart_toy),
              label: Text(t('AI Destek Al', 'Get AI Support')),
              onPressed: () {
                openAiSupport(
                  extraText:
                      '${t('Bu soruyla ilgili destek almak istiyorum', 'I would like support about this question')}:\n${question['question']}',
                );
              },
            ),
            const SizedBox(height: 20),
            ...List.generate(question['answers'].length, (index) {
              final answer = question['answers'][index];

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => answerQuestion(answer['point']),
                  child: Text(answer['text']),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

const commonAnswersTr = [
  {'text': 'Evet, çoğu zaman', 'point': 3},
  {'text': 'Bazen', 'point': 2},
  {'text': 'Hayır', 'point': 1},
];

const commonAnswersEn = [
  {'text': 'Yes, most of the time', 'point': 3},
  {'text': 'Sometimes', 'point': 2},
  {'text': 'No', 'point': 1},
];

const spouseQuestionsTr = [
  {
    'question': 'Eşin seni dikkatle dinlediğini hissettiriyor mu?',
    'answers': commonAnswersTr,
  },
  {
    'question': 'Sorunlarınızı konuşarak çözebiliyor musunuz?',
    'answers': [
      {'text': 'Evet, çoğu zaman', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Genelde tartışmaya dönüşüyor', 'point': 1},
    ],
  },
  {
    'question': 'Kendini bu ilişkide değerli hissediyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Çoğu zaman hayır', 'point': 1},
    ],
  },
  {
    'question': 'Eşin zor zamanlarında sana destek oluyor mu?',
    'answers': [
      {'text': 'Evet, yanımda olur', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Hayır, yalnız hissederim', 'point': 1},
    ],
  },
  {
    'question': 'Birlikte kaliteli zaman geçiriyor musunuz?',
    'answers': [
      {'text': 'Evet, düzenli olarak', 'point': 3},
      {'text': 'Ara sıra', 'point': 2},
      {'text': 'Neredeyse hiç', 'point': 1},
    ],
  },
  {
    'question': 'Maddi konularda ortak karar alabiliyor musunuz?',
    'answers': commonAnswersTr,
  },
  {
    'question': 'Eşin ailene saygılı davranıyor mu?',
    'answers': commonAnswersTr,
  },
  {
    'question': 'Eşin kendi ailesi ile senin arasında denge kurabiliyor mu?',
    'answers': [
      {'text': 'Evet, adil davranıyor', 'point': 3},
      {'text': 'Bazen zorlanıyor', 'point': 2},
      {'text': 'Hayır, genelde ailesinden yana', 'point': 1},
    ],
  },
  {
    'question': 'Fikir ayrılıklarında sana saygılı davranıyor mu?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Hayır, kırıcı olabiliyor', 'point': 1},
    ],
  },
  {
    'question': 'Bu evlilikte kendini güvende hissediyor musun?',
    'answers': [
      {'text': 'Evet, güvende hissediyorum', 'point': 3},
      {'text': 'Bazen emin değilim', 'point': 2},
      {'text': 'Hayır, güvende hissetmiyorum', 'point': 1},
    ],
  },
];

const spouseQuestionsEn = [
  {
    'question': 'Does your spouse make you feel carefully listened to?',
    'answers': commonAnswersEn,
  },
  {
    'question': 'Can you solve your problems by talking?',
    'answers': [
      {'text': 'Yes, most of the time', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'It usually turns into an argument', 'point': 1},
    ],
  },
  {
    'question': 'Do you feel valued in this relationship?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Mostly no', 'point': 1},
    ],
  },
  {
    'question': 'Does your spouse support you during difficult times?',
    'answers': [
      {'text': 'Yes, they stand by me', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'No, I feel alone', 'point': 1},
    ],
  },
  {
    'question': 'Do you spend quality time together?',
    'answers': [
      {'text': 'Yes, regularly', 'point': 3},
      {'text': 'Occasionally', 'point': 2},
      {'text': 'Almost never', 'point': 1},
    ],
  },
  {
    'question': 'Can you make shared decisions about financial matters?',
    'answers': commonAnswersEn,
  },
  {
    'question': 'Does your spouse treat your family respectfully?',
    'answers': commonAnswersEn,
  },
  {
    'question': 'Can your spouse balance their family and you fairly?',
    'answers': [
      {'text': 'Yes, they are fair', 'point': 3},
      {'text': 'Sometimes they struggle', 'point': 2},
      {'text': 'No, they usually side with their family', 'point': 1},
    ],
  },
  {
    'question': 'Do they treat you respectfully during disagreements?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'No, they can be hurtful', 'point': 1},
    ],
  },
  {
    'question': 'Do you feel safe in this marriage?',
    'answers': [
      {'text': 'Yes, I feel safe', 'point': 3},
      {'text': 'Sometimes I am not sure', 'point': 2},
      {'text': 'No, I do not feel safe', 'point': 1},
    ],
  },
];

const brideQuestionsTr = [
  {
    'question': 'Yeni aile ortamında kendini kabul edilmiş hissediyor musun?',
    'answers': [
      {'text': 'Evet, çoğu zaman', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Hayır, dışlanmış hissediyorum', 'point': 1},
    ],
  },
  {
    'question': 'Eşinin ailesiyle sınırlarını rahat koruyabiliyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Kısmen', 'point': 2},
      {'text': 'Hayır, zorlanıyorum', 'point': 1},
    ],
  },
  {
    'question':
        'Kayınvalidenle yaşadığın sorunlarda eşinden destek alabiliyor musun?',
    'answers': commonAnswersTr,
  },
  {
    'question': 'Gelin olarak sürekli beklenti altında hissediyor musun?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, çok sık', 'point': 1},
    ],
  },
  {
    'question':
        'Kendi kararlarını alırken aile büyüklerinden baskı görüyor musun?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Ara sıra', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1},
    ],
  },
  {
    'question':
        'Eşinin ailesi seni başka gelinlerle veya kadınlarla kıyaslıyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1},
    ],
  },
  {
    'question': 'Aile toplantılarında rahat davranabiliyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Kısmen', 'point': 2},
      {'text': 'Hayır, sürekli dikkatliyim', 'point': 1},
    ],
  },
  {
    'question': 'Gelin olarak emeğinin görüldüğünü hissediyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Hayır, çoğu zaman görülmüyor', 'point': 1},
    ],
  },
  {
    'question': 'Aile içinde kendi fikrini söyleyebiliyor musun?',
    'answers': [
      {'text': 'Evet, rahatça', 'point': 3},
      {'text': 'Bazen çekiniyorum', 'point': 2},
      {'text': 'Hayır, susmayı tercih ediyorum', 'point': 1},
    ],
  },
  {
    'question': 'Eşin senin aile içinde yalnız kalmanı önleyebiliyor mu?',
    'answers': [
      {'text': 'Evet, destek olur', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Hayır, yalnız kalıyorum', 'point': 1},
    ],
  },
];

const brideQuestionsEn = [
  {
    'question': 'Do you feel accepted in your new family environment?',
    'answers': [
      {'text': 'Yes, most of the time', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'No, I feel excluded', 'point': 1},
    ],
  },
  {
    'question':
        'Can you comfortably protect your boundaries with your spouse’s family?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Partly', 'point': 2},
      {'text': 'No, I struggle', 'point': 1},
    ],
  },
  {
    'question':
        'Can you get support from your spouse in problems with your mother-in-law?',
    'answers': commonAnswersEn,
  },
  {
    'question': 'Do you constantly feel under expectations as a bride?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, very often', 'point': 1},
    ],
  },
  {
    'question': 'Do elders pressure you when you make your own decisions?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Occasionally', 'point': 2},
      {'text': 'Yes, often', 'point': 1},
    ],
  },
  {
    'question':
        'Does your spouse’s family compare you with other brides or women?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1},
    ],
  },
  {
    'question': 'Can you act comfortably at family gatherings?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Partly', 'point': 2},
      {'text': 'No, I am always careful', 'point': 1},
    ],
  },
  {
    'question': 'Do you feel your effort as a bride is noticed?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'No, often it is not noticed', 'point': 1},
    ],
  },
  {
    'question': 'Can you express your opinion within the family?',
    'answers': [
      {'text': 'Yes, comfortably', 'point': 3},
      {'text': 'Sometimes I hesitate', 'point': 2},
      {'text': 'No, I prefer to stay silent', 'point': 1},
    ],
  },
  {
    'question':
        'Can your spouse prevent you from feeling alone within the family?',
    'answers': [
      {'text': 'Yes, they support me', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'No, I feel alone', 'point': 1},
    ],
  },
];

const motherInLawQuestionsTr = [
  {
    'question': 'Kayınvaliden özel hayatına müdahale ediyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Ara sıra', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Çocuk yetiştirme kararlarına karışıyor mu?',
    'answers': [
      {'text': 'Hayır, saygı duyar', 'point': 3},
      {'text': 'Bazen karışır', 'point': 2},
      {'text': 'Evet, çok karışır', 'point': 1}
    ]
  },
  {
    'question': 'Evin düzeni konusunda seni eleştiriyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Seni başka gelinlerle veya kadınlarla kıyaslıyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Yanında kendini rahat ifade edebiliyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Kısmen', 'point': 2},
      {'text': 'Hayır', 'point': 1}
    ]
  },
  {
    'question': 'Eşin kayınvalideyle yaşanan konularda seni destekliyor mu?',
    'answers': commonAnswersTr
  },
  {'question': 'Kararlarına saygı duyuyor mu?', 'answers': commonAnswersTr},
  {
    'question': 'Seni olduğu gibi kabul ettiğini hissediyor musun?',
    'answers': commonAnswersTr
  },
  {
    'question': 'Sınırlarına saygı gösteriyor mu?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Ara sıra', 'point': 2},
      {'text': 'Hayır, çoğu zaman ihlal ediyor', 'point': 1}
    ]
  },
  {
    'question':
        'Onun yanında sürekli dikkatli davranmak zorunda hissediyor musun?',
    'answers': [
      {'text': 'Hayır, rahatım', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sürekli', 'point': 1}
    ]
  },
];

const motherInLawQuestionsEn = [
  {
    'question': 'Does your mother-in-law interfere in your private life?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Occasionally', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Does she interfere with parenting decisions?',
    'answers': [
      {'text': 'No, she respects them', 'point': 3},
      {'text': 'Sometimes she interferes', 'point': 2},
      {'text': 'Yes, a lot', 'point': 1}
    ]
  },
  {
    'question': 'Does she criticize you about the order of your home?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Does she compare you with other brides or women?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Can you express yourself comfortably around her?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Partly', 'point': 2},
      {'text': 'No', 'point': 1}
    ]
  },
  {
    'question':
        'Does your spouse support you in issues involving your mother-in-law?',
    'answers': commonAnswersEn
  },
  {'question': 'Does she respect your decisions?', 'answers': commonAnswersEn},
  {'question': 'Do you feel accepted as you are?', 'answers': commonAnswersEn},
  {
    'question': 'Does she respect your boundaries?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Occasionally', 'point': 2},
      {'text': 'No, she often violates them', 'point': 1}
    ]
  },
  {
    'question': 'Do you feel you always have to be careful around her?',
    'answers': [
      {'text': 'No, I am comfortable', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, constantly', 'point': 1}
    ]
  },
];

const sisterInLawQuestionsTr = [
  {
    'question': 'Görümcen özel hayatına fazla ilgi gösteriyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, çok fazla', 'point': 1}
    ]
  },
  {
    'question': 'Aranızda kıskançlık veya rekabet hissediyor musun?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Seni aile içinde eleştiriyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Özel bilgilerini başkalarıyla paylaşıyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen olabilir', 'point': 2},
      {'text': 'Evet, güvenemiyorum', 'point': 1}
    ]
  },
  {
    'question': 'Kendini onunla kıyaslanmış hissediyor musun?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Sana karşı samimi olduğunu düşünüyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Emin değilim', 'point': 2},
      {'text': 'Hayır', 'point': 1}
    ]
  },
  {
    'question': 'Eşinle ilgili konularda yorum yapıyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, çok karışıyor', 'point': 1}
    ]
  },
  {
    'question': 'Aile içinde taraf tutuyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Çocuklar üzerinden rekabet hissediyor musun?',
    'answers': commonAnswersTr
  },
  {
    'question': 'Onun yanında rahat davranabiliyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Kısmen', 'point': 2},
      {'text': 'Hayır, dikkatliyim', 'point': 1}
    ]
  },
];

const sisterInLawQuestionsEn = [
  {
    'question':
        'Does your sister-in-law show too much interest in your private life?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, too much', 'point': 1}
    ]
  },
  {
    'question': 'Do you feel jealousy or competition between you?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Does she criticize you within the family?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Does she share your private information with others?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes maybe', 'point': 2},
      {'text': 'Yes, I cannot trust her', 'point': 1}
    ]
  },
  {
    'question': 'Do you feel compared with her?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Do you think she is sincere toward you?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'I am not sure', 'point': 2},
      {'text': 'No', 'point': 1}
    ]
  },
  {
    'question': 'Does she comment on matters about your spouse?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, she interferes a lot', 'point': 1}
    ]
  },
  {
    'question': 'Does she take sides within the family?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Do you feel competition through children?',
    'answers': commonAnswersEn
  },
  {
    'question': 'Can you act comfortably around her?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Partly', 'point': 2},
      {'text': 'No, I am careful', 'point': 1}
    ]
  },
];

const coSisterInLawQuestionsTr = [
  {
    'question': 'Eltinle kendini kıyaslanmış hissediyor musun?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Çocuklarınız kıyaslanıyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Aile büyüklerine yakınlık yarışı hissediyor musun?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, belirgin', 'point': 1}
    ]
  },
  {
    'question': 'Aranızda güven var mı?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Kısmen', 'point': 2},
      {'text': 'Hayır', 'point': 1}
    ]
  },
  {
    'question': 'Dedikodu yapıldığını düşünüyor musun?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen şüpheleniyorum', 'point': 2},
      {'text': 'Evet, sık oluyor', 'point': 1}
    ]
  },
  {
    'question': 'Başarıların veya emeğin küçümseniyor mu?',
    'answers': commonAnswersTr
  },
  {
    'question': 'Maddi konularda rekabet hissediyor musun?',
    'answers': commonAnswersTr
  },
  {
    'question': 'Aile toplantılarında gerginlik oluyor mu?',
    'answers': [
      {'text': 'Hayır', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Evet, sık sık', 'point': 1}
    ]
  },
  {
    'question': 'Sana karşı dürüst olduğunu düşünüyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Emin değilim', 'point': 2},
      {'text': 'Hayır', 'point': 1}
    ]
  },
  {
    'question': 'Onun yanında kendin olabiliyor musun?',
    'answers': commonAnswersTr
  },
];

const coSisterInLawQuestionsEn = [
  {
    'question': 'Do you feel compared with your co-sister-in-law?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Are your children compared?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Do you feel competition for closeness to family elders?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, clearly', 'point': 1}
    ]
  },
  {
    'question': 'Is there trust between you?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Partly', 'point': 2},
      {'text': 'No', 'point': 1}
    ]
  },
  {
    'question': 'Do you think gossip happens?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes I suspect it', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Are your achievements or efforts belittled?',
    'answers': commonAnswersEn
  },
  {
    'question': 'Do you feel competition around financial matters?',
    'answers': commonAnswersEn
  },
  {
    'question': 'Is there tension at family gatherings?',
    'answers': [
      {'text': 'No', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Yes, often', 'point': 1}
    ]
  },
  {
    'question': 'Do you think she is honest with you?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'I am not sure', 'point': 2},
      {'text': 'No', 'point': 1}
    ]
  },
  {'question': 'Can you be yourself around her?', 'answers': commonAnswersEn},
];

const childrenQuestionsTr = [
  {
    'question': 'Çocuğun duygularını sana anlatabiliyor mu?',
    'answers': [
      {'text': 'Evet, rahatça', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Hayır, içine atıyor', 'point': 1}
    ]
  },
  {
    'question': 'Kuralları açıklayarak koyabiliyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Genelde kızarak söylüyorum', 'point': 1}
    ]
  },
  {
    'question': 'Birlikte kaliteli zaman geçiriyor musunuz?',
    'answers': [
      {'text': 'Sık sık', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Çok az', 'point': 1}
    ]
  },
  {
    'question': 'Çocuğun ekran süresini yönetebiliyor musun?',
    'answers': [
      {'text': 'Evet, dengeli', 'point': 3},
      {'text': 'Bazen zorlanıyorum', 'point': 2},
      {'text': 'Hayır, çok zorlanıyorum', 'point': 1}
    ]
  },
  {
    'question': 'Öfkelendiğinde sakin kalabiliyor musun?',
    'answers': [
      {'text': 'Çoğu zaman', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Genelde zorlanıyorum', 'point': 1}
    ]
  },
  {
    'question': 'Çocuğun hata yaptığında sana gelebiliyor mu?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Bazen çekiniyor', 'point': 2},
      {'text': 'Hayır, korkuyor', 'point': 1}
    ]
  },
  {
    'question': 'Sana güvendiğini hissediyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Bazen emin değilim', 'point': 2},
      {'text': 'Hayır gibi', 'point': 1}
    ]
  },
  {
    'question': 'Sorumluluk almasını destekliyor musun?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Hayır, zorlanıyoruz', 'point': 1}
    ]
  },
  {
    'question': 'Çocuğun kendini evde güvende hissediyor mu?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Bazen emin değilim', 'point': 2},
      {'text': 'Hayır gibi', 'point': 1}
    ]
  },
  {
    'question': 'Onunla konuşurken gerçekten dinliyor musun?',
    'answers': [
      {'text': 'Evet, dikkatle', 'point': 3},
      {'text': 'Bazen', 'point': 2},
      {'text': 'Hayır, çoğu zaman acele ediyorum', 'point': 1}
    ]
  },
];

const childrenQuestionsEn = [
  {
    'question': 'Can your child tell you about their emotions?',
    'answers': [
      {'text': 'Yes, comfortably', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'No, they keep it inside', 'point': 1}
    ]
  },
  {
    'question': 'Can you set rules by explaining them?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'I usually say it angrily', 'point': 1}
    ]
  },
  {
    'question': 'Do you spend quality time together?',
    'answers': [
      {'text': 'Often', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Very little', 'point': 1}
    ]
  },
  {
    'question': 'Can you manage your child’s screen time?',
    'answers': [
      {'text': 'Yes, balanced', 'point': 3},
      {'text': 'Sometimes I struggle', 'point': 2},
      {'text': 'No, I struggle a lot', 'point': 1}
    ]
  },
  {
    'question': 'Can you stay calm when you get angry?',
    'answers': [
      {'text': 'Most of the time', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'Usually I struggle', 'point': 1}
    ]
  },
  {
    'question': 'Can your child come to you when they make a mistake?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Sometimes they hesitate', 'point': 2},
      {'text': 'No, they are afraid', 'point': 1}
    ]
  },
  {
    'question': 'Do you feel your child trusts you?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Sometimes I am not sure', 'point': 2},
      {'text': 'Not really', 'point': 1}
    ]
  },
  {
    'question': 'Do you support them in taking responsibility?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'No, we struggle', 'point': 1}
    ]
  },
  {
    'question': 'Does your child feel safe at home?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Sometimes I am not sure', 'point': 2},
      {'text': 'Not really', 'point': 1}
    ]
  },
  {
    'question': 'Do you truly listen when talking with them?',
    'answers': [
      {'text': 'Yes, carefully', 'point': 3},
      {'text': 'Sometimes', 'point': 2},
      {'text': 'No, I often rush', 'point': 1}
    ]
  },
];

const familyQuestionsTr = [
  {
    'question': 'Evde herkesin fikri dinleniyor mu?',
    'answers': commonAnswersTr
  },
  {
    'question': 'Ev içinde sorumluluklar adil paylaşılıyor mu?',
    'answers': [
      {'text': 'Evet', 'point': 3},
      {'text': 'Kısmen', 'point': 2},
      {'text': 'Hayır', 'point': 1}
    ]
  },
  {'question': 'Evde huzurlu hissediyor musun?', 'answers': commonAnswersTr},
];

const familyQuestionsEn = [
  {
    'question': 'Is everyone’s opinion listened to at home?',
    'answers': commonAnswersEn
  },
  {
    'question': 'Are responsibilities fairly shared at home?',
    'answers': [
      {'text': 'Yes', 'point': 3},
      {'text': 'Partly', 'point': 2},
      {'text': 'No', 'point': 1}
    ]
  },
  {'question': 'Do you feel peaceful at home?', 'answers': commonAnswersEn},
];
