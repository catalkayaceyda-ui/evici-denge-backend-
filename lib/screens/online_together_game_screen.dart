import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnlineTogetherGameScreen extends StatefulWidget {
  final String languageCode;

  const OnlineTogetherGameScreen({
    super.key,
    required this.languageCode,
  });

  @override
  State<OnlineTogetherGameScreen> createState() =>
      _OnlineTogetherGameScreenState();
}

class _OnlineTogetherGameScreenState extends State<OnlineTogetherGameScreen> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  String t(String tr, String en) {
    return widget.languageCode == 'en' ? en : tr;
  }

  String generateCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> createGame(String relation) async {
    setState(() {
      isLoading = true;
    });

    try {
      final code = generateCode();

      await Supabase.instance.client.from('aile_oyunlari').insert({
        'code': code,
        'relation': relation,
        'player1_answers': {},
        'player2_answers': {},
        'player2_joined': false,
        'status': 'waiting',
      });

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameRoomScreen(
            code: code,
            isPlayer1: true,
            languageCode: widget.languageCode,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oyun oluşturulamadı: $e'),
          duration: const Duration(seconds: 6),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> joinGame() async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('Kod yazmalısın', 'Please enter a code'))),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await Supabase.instance.client
          .from('aile_oyunlari')
          .select()
          .eq('code', code)
          .maybeSingle();

      if (result == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t('Oyun bulunamadı', 'Game not found'))),
        );
        return;
      }

      await Supabase.instance.client.from('aile_oyunlari').update({
        'player2_joined': true,
        'status': 'started',
      }).eq('code', code);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameRoomScreen(
            code: code,
            isPlayer1: false,
            languageCode: widget.languageCode,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oyuna katılınamadı: $e'),
          duration: const Duration(seconds: 6),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final relations = [
      '❤️ ${t('Eşimle', 'With my spouse')}',
      '👵 ${t('Kaynanamla', 'With my mother-in-law')}',
      '👭 ${t('Görümcemle', 'With my sister-in-law')}',
      '🤝 ${t('Eltimle', 'With my co-sister')}',
      '👩 ${t('Annemle', 'With my mother')}',
      '👶 ${t('Çocuğumla', 'With my child')}',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t('Birlikte Oyna', 'Play Together')),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                t('Kiminle oynamak istiyorsun?',
                    'Who do you want to play with?'),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              ...relations.map(
                (relation) => Card(
                  child: ListTile(
                    title: Text(relation),
                    trailing: const Icon(Icons.play_arrow),
                    onTap: isLoading ? null : () => createGame(relation),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Divider(),
              const SizedBox(height: 18),
              Text(
                t('Kodla oyuna katıl', 'Join with code'),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t('6 haneli oyun kodu', '6-digit game code'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: Text(t('Oyuna Katıl', 'Join Game')),
                onPressed: isLoading ? null : joinGame,
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.15),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class GameRoomScreen extends StatefulWidget {
  final String code;
  final bool isPlayer1;
  final String languageCode;

  const GameRoomScreen({
    super.key,
    required this.code,
    required this.isPlayer1,
    required this.languageCode,
  });

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  int currentQuestion = 0;

  String t(String tr, String en) {
    return widget.languageCode == 'en' ? en : tr;
  }

  List<Map<String, dynamic>> get questions => [
        {
          'question': t(
            'Benim en çok önem verdiğim şey nedir?',
            'What do I value most?',
          ),
          'answers': [
            t('Saygı', 'Respect'),
            t('Güven', 'Trust'),
            t('Sevgi', 'Love'),
            t('Özgürlük', 'Freedom'),
          ],
        },
        {
          'question': t(
            'Tartışınca ilk tepkim nedir?',
            'What is my first reaction during an argument?',
          ),
          'answers': [
            t('Susarım', 'I stay silent'),
            t('Konuşurum', 'I talk'),
            t('Uzaklaşırım', 'I walk away'),
            t('Ağlarım', 'I cry'),
          ],
        },
        {
          'question': t(
            'Beni en çok mutlu eden şey nedir?',
            'What makes me happiest?',
          ),
          'answers': [
            t('Hediye', 'Gift'),
            t('Takdir', 'Appreciation'),
            t('Yardım', 'Help'),
            t('Birlikte vakit', 'Time together'),
          ],
        },
        {
          'question': t(
            'Benden en çok ne beklersin?',
            'What do you expect from me most?',
          ),
          'answers': [
            t('Destek', 'Support'),
            t('Anlayış', 'Understanding'),
            t('Saygı', 'Respect'),
            t('İlgi', 'Attention'),
          ],
        },
        {
          'question': t(
            'İlişkimizde en güçlü yan nedir?',
            'What is the strongest part of our relationship?',
          ),
          'answers': [
            t('Sevgi', 'Love'),
            t('Sabır', 'Patience'),
            t('Bağlılık', 'Loyalty'),
            t('Fedakarlık', 'Sacrifice'),
          ],
        },
      ];

  Future<void> saveAnswer(String answer) async {
    try {
      final data = await Supabase.instance.client
          .from('aile_oyunlari')
          .select()
          .eq('code', widget.code)
          .maybeSingle();

      if (data == null) return;

      final field = widget.isPlayer1 ? 'player1_answers' : 'player2_answers';
      final oldAnswers = Map<String, dynamic>.from(data[field] ?? {});

      oldAnswers[currentQuestion.toString()] = answer;

      await Supabase.instance.client
          .from('aile_oyunlari')
          .update({field: oldAnswers}).eq('code', widget.code);

      if (currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
        });
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GameResultScreen(
              code: widget.code,
              languageCode: widget.languageCode,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cevap kaydedilemedi: $e'),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('${t('Kod', 'Code')}: ${widget.code}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                '${t('Benimle Ev İçi Denge oyununu oyna', 'Play Home Balance with me')} 💛\n${t('Oyun kodum', 'My game code')}: ${widget.code}',
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('aile_oyunlari')
            .stream(primaryKey: ['id']).eq('code', widget.code),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Bağlantı hatası: ${snapshot.error}'),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data!;
          if (rows.isEmpty) {
            return Center(child: Text(t('Oyun bulunamadı', 'Game not found')));
          }

          final data = rows.first;
          final player2Joined = data['player2_joined'] == true;

          if (!player2Joined) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t('Karşı taraf bekleniyor...',
                          'Waiting for other player...'),
                      style: const TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.code,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.share),
                      label: Text(t('Kodu Gönder', 'Send Code')),
                      onPressed: () {
                        Share.share(
                          '${t('Benimle Ev İçi Denge oyununu oyna', 'Play Home Balance with me')} 💛\n${t('Oyun kodum', 'My game code')}: ${widget.code}',
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  question['question'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ...(question['answers'] as List<String>).map(
                  (answer) => Card(
                    child: ListTile(
                      title: Text(answer),
                      onTap: () => saveAnswer(answer),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GameResultScreen extends StatelessWidget {
  final String code;
  final String languageCode;

  const GameResultScreen({
    super.key,
    required this.code,
    required this.languageCode,
  });

  String t(String tr, String en) {
    return languageCode == 'en' ? en : tr;
  }

  int calculateScore(Map<String, dynamic> p1, Map<String, dynamic> p2) {
    int match = 0;
    const total = 5;

    for (int i = 0; i < total; i++) {
      final key = i.toString();
      if (p1[key] != null && p1[key] == p2[key]) {
        match++;
      }
    }

    return ((match / total) * 100).round();
  }

  String resultText(int score) {
    if (score >= 80) {
      return t(
        'Birbirinizi çok iyi tanıyorsunuz 💛',
        'You know each other very well 💛',
      );
    } else if (score >= 60) {
      return t(
        'Güzel bir uyum var ama konuşulacak konular da var 🌿',
        'There is good harmony, but some topics need conversation 🌿',
      );
    } else if (score >= 40) {
      return t(
        'Birbirinizi daha iyi anlamaya ihtiyacınız var 💬',
        'You need to understand each other better 💬',
      );
    } else {
      return t(
        'Bu oyun size konuşmanız gereken şeyleri gösterebilir 🤍',
        'This game may show what you need to talk about 🤍',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('Uyum Sonucu', 'Harmony Result')),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('aile_oyunlari')
            .stream(primaryKey: ['id']).eq('code', code),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Bağlantı hatası: ${snapshot.error}'),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data!;
          if (rows.isEmpty) {
            return Center(child: Text(t('Oyun bulunamadı', 'Game not found')));
          }

          final data = rows.first;

          final p1 = Map<String, dynamic>.from(data['player1_answers'] ?? {});
          final p2 = Map<String, dynamic>.from(data['player2_answers'] ?? {});

          if (p1.length < 5 || p2.length < 5) {
            return Center(
              child: Text(
                t(
                  'Diğer oyuncunun cevapları bekleniyor...',
                  'Waiting for the other player’s answers...',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            );
          }

          final score = calculateScore(p1, p2);

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t('Uyum Puanınız', 'Your Harmony Score'),
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '%$score',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    resultText(score),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22),
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
