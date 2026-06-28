import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

class EmotionJournalScreen extends StatefulWidget {
  const EmotionJournalScreen({super.key});

  @override
  State<EmotionJournalScreen> createState() => _EmotionJournalScreenState();
}

class _EmotionJournalScreenState extends State<EmotionJournalScreen> {
  final ImagePicker picker = ImagePicker();
  final AudioPlayer audioPlayer = AudioPlayer();
  late stt.SpeechToText speech;

  bool showCover = true;
  bool showList = false;
  int currentPage = 0;
  bool isListening = false;
  bool isPlaying = false;
  String statusText = 'Konuşmaya başlamak için mikrofona bas.';

  String getNowText() {
    final now = DateTime.now();
    return '${now.day}.${now.month}.${now.year} - ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> createEmptyPage() {
    return {
      'emoji': '😊',
      'text': '',
      'image': null,
      'date': getNowText(),
      'saved': false,
      'songName': null,
      'songBytes': null,
      'songPath': null,
      'magicImageText': null,
      'aiAnalysis': null,
    };
  }

  late final List<Map<String, dynamic>> pages = [
    createEmptyPage(),
  ];

  final List<String> emojis = ['😢', '😔', '😐', '😊', '😍', '😡', '😴', '🙏'];

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    speech.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void openList() {
    setState(() {
      showCover = false;
      showList = true;
    });
  }

  void openDetail(int index) {
    setState(() {
      currentPage = index;
      showCover = false;
      showList = false;
    });
  }

  void addNewPage() {
    setState(() {
      pages.add(createEmptyPage());
      currentPage = pages.length - 1;
      showCover = false;
      showList = false;
    });
  }

  void deletePage() {
    audioPlayer.stop();

    if (pages.length == 1) {
      setState(() {
        pages[0] = createEmptyPage();
      });
      return;
    }

    setState(() {
      pages.removeAt(currentPage);
      currentPage = 0;
      showList = true;
    });
  }

  void savePage() {
    setState(() {
      pages[currentPage]['saved'] = true;
      pages[currentPage]['date'] = getNowText();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sayfa kaydedildi')),
    );
  }

  void updateEmoji(String emoji) {
    setState(() {
      pages[currentPage]['emoji'] = emoji;
    });
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final Uint8List bytes = await image.readAsBytes();

    setState(() {
      pages[currentPage]['image'] = bytes;
    });
  }

  Future<void> pickSong() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    setState(() {
      pages[currentPage]['songName'] = file.name;
      pages[currentPage]['songBytes'] = file.bytes;
      pages[currentPage]['songPath'] = file.path;
    });
  }

  Future<void> playSong() async {
    final Uint8List? bytes = pages[currentPage]['songBytes'];
    final String? path = pages[currentPage]['songPath'];

    if (bytes == null && path == null) return;

    await audioPlayer.stop();

    if (bytes != null) {
      await audioPlayer.play(BytesSource(bytes));
    } else if (path != null) {
      await audioPlayer.play(DeviceFileSource(path));
    }

    setState(() {
      isPlaying = true;
    });
  }

  Future<void> stopSong() async {
    await audioPlayer.stop();

    setState(() {
      isPlaying = false;
    });
  }

  void removeSong() {
    audioPlayer.stop();

    setState(() {
      isPlaying = false;
      pages[currentPage]['songName'] = null;
      pages[currentPage]['songBytes'] = null;
      pages[currentPage]['songPath'] = null;
    });
  }

  Future<void> startListening() async {
    final available = await speech.initialize();

    if (!available) {
      setState(() {
        statusText = 'Mikrofon izni alınamadı.';
      });
      return;
    }

    setState(() {
      isListening = true;
      statusText = 'Dinliyorum... Konuşabilirsin.';
    });

    speech.listen(
      localeId: 'tr_TR',
      onResult: (result) {
        setState(() {
          pages[currentPage]['text'] = result.recognizedWords;
        });
      },
    );
  }

  void stopListening() {
    speech.stop();

    setState(() {
      isListening = false;
      statusText = 'Dinleme durdu.';
    });
  }

  void showStats() {
    final stats = <String, int>{};

    for (final emoji in emojis) {
      stats[emoji] = pages.where((e) => e['emoji'] == emoji).length;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('📊 Duygu İstatistikleri'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...stats.entries.map(
              (entry) => Text('${entry.key} : ${entry.value}'),
            ),
            const Divider(),
            Text('📔 Toplam Sayfa: ${pages.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  void createMagicImageText() {
    final text = pages[currentPage]['text'] ?? '';
    final emoji = pages[currentPage]['emoji'] ?? '😐';

    String result;

    if (text.toString().trim().isEmpty) {
      result = 'Önce günlüğüne bir şeyler yazmalısın.';
    } else if (emoji == '😢' || emoji == '😔') {
      result =
          '🌧 Bu yazının resmi: Yağmurlu eski bir pencere, loş ışık, masada açık bir günlük ve içinde saklanan kırgın bir kalp.';
    } else if (emoji == '😊' || emoji == '😍') {
      result =
          '🌞 Bu yazının resmi: Altın ışıklı bir bahçe, sıcak bir gün batımı, gülümseyen anılar ve parlayan küçük yıldızlar.';
    } else if (emoji == '😡') {
      result =
          '🔥 Bu yazının resmi: Karanlık gökyüzü altında parlayan ateş kıvılcımları, güçlü ama sakinleşmeye çalışan bir ruh.';
    } else if (emoji == '😴') {
      result =
          '🌙 Bu yazının resmi: Sessiz bir orman, ay ışığı, yumuşak sis ve dinlenmek isteyen yorgun bir kalp.';
    } else {
      result =
          '✨ Bu yazının resmi: Eski bir parşömen üzerinde parlayan büyülü izler ve senin yaşadıklarını anlatan gizli bir sahne.';
    }

    setState(() {
      pages[currentPage]['magicImageText'] = result;
    });
  }

  void analyzeJournal() {
    final text = pages[currentPage]['text'] ?? '';
    final emoji = pages[currentPage]['emoji'] ?? '😐';

    String analysis;

    if (text.toString().trim().isEmpty) {
      analysis = 'Önce günlüğüne bir şeyler yazmalısın.';
    } else if (emoji == '😢' || emoji == '😔') {
      analysis =
          '🤖 Günlük Analizi\n\nYazında üzüntü, kırgınlık veya içe atılmış bir duygu öne çıkıyor. Bugün kendini zorlamadan, seni yoran şeyi küçük parçalara ayırman iyi olabilir. Birine her şeyi anlatmak zorunda değilsin; önce kendine karşı dürüst olman yeterli.';
    } else if (emoji == '😊' || emoji == '😍') {
      analysis =
          '🤖 Günlük Analizi\n\nYazında olumlu ve besleyici bir duygu var. Sana iyi gelen şeyi fark etmişsin. Bu duyguyu büyütmek için bugün seni mutlu eden şeyi not et ve mümkünse tekrar et.';
    } else if (emoji == '😡') {
      analysis =
          '🤖 Günlük Analizi\n\nYazında öfke, gerilim veya haksızlığa uğrama hissi olabilir. Şu an hemen cevap vermek yerine biraz beklemek iyi olur. Duygunu “Ben böyle hissettim” diye ifade etmek tartışmayı büyütmeden sınır koymana yardımcı olur.';
    } else if (emoji == '😴') {
      analysis =
          '🤖 Günlük Analizi\n\nYazında yorgunluk ve tükenmişlik hissi öne çıkıyor. Bugün her şeyi çözmek zorunda değilsin. Küçük bir mola, su içmek, kısa yürüyüş veya erken uyumak bile zihnini toparlayabilir.';
    } else if (emoji == '🙏') {
      analysis =
          '🤖 Günlük Analizi\n\nYazında içsel destek ve sakinleşme ihtiyacı var. Dua etmek, sessizce oturmak, nefes egzersizi yapmak veya güvendiğin biriyle kısa bir konuşma kalbine iyi gelebilir.';
    } else {
      analysis =
          '🤖 Günlük Analizi\n\nYazında karışık duygular var. Şu an seni en çok etkileyen şeyi seçip sadece onun üzerine düşünmek iyi olabilir. Büyük kararlar yerine küçük ve güvenli bir adım atman daha sağlıklı olur.';
    }

    setState(() {
      pages[currentPage]['aiAnalysis'] = analysis;
    });
  }

  Widget magicButton(IconData icon, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4E342E),
          foregroundColor: const Color(0xFFFFD54F),
        ),
      ),
    );
  }

  Widget buildCover() {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0F08),
      body: Center(
        child: GestureDetector(
          onTap: openList,
          child: Container(
            width: 330,
            height: 480,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7B3F1D), Color(0xFF3E1F0D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFFFD54F),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 25,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 70,
                  color: Color(0xFFFFD54F),
                ),
                SizedBox(height: 25),
                Text(
                  'SİHİRLİ\nGÜNLÜĞÜM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFECB3),
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  'Dokun ve günlüğünü aç',
                  style: TextStyle(
                    color: Color(0xFFFFD54F),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 40),
                Icon(
                  Icons.lock,
                  color: Color(0xFFFFD54F),
                  size: 42,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF3E2723),
        selectedItemColor: const Color(0xFFFFD54F),
        unselectedItemColor: const Color(0xFFFFECB3),
        onTap: (i) {
          if (i == 0) openList();
          if (i == 1) showStats();
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Günlüklerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'İstatistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Kilit',
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return Scaffold(
      backgroundColor: const Color(0xFF2B160B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: const Color(0xFFFFD54F),
        title: const Text('📖 Günlüklerim'),
        actions: [
          IconButton(
            onPressed: addNewPage,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: showStats,
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final item = pages[index];

          return Card(
            color: const Color(0xFFF5E6C8),
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              leading: Text(
                item['emoji'].toString(),
                style: const TextStyle(fontSize: 30),
              ),
              title: Text(
                item['date'].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                item['text'].toString().isEmpty
                    ? 'Henüz yazı eklenmedi...'
                    : item['text'].toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => openDetail(index),
            ),
          );
        },
      ),
    );
  }

  Widget buildDetail() {
    final item = pages[currentPage];

    return Scaffold(
      backgroundColor: const Color(0xFF2B160B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: const Color(0xFFFFD54F),
        title: const Text('📜 Büyülü Sayfa'),
        actions: [
          IconButton(
            onPressed: savePage,
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: deletePage,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E6C8),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color(0xFF8D6E63),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                item['date'].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E342E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['saved'] == true ? '✅ Kaydedildi' : 'Henüz kaydedilmedi',
                style: TextStyle(
                  color: item['saved'] == true ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: emojis.map((emoji) {
                  return ChoiceChip(
                    label: Text(
                      emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                    selected: item['emoji'] == emoji,
                    onSelected: (_) => updateEmoji(emoji),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              if (item['image'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(
                    item['image'],
                    height: 160,
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              const SizedBox(height: 10),
              magicButton(Icons.photo, 'Anı Fotoğrafı Ekle', pickImage),
              const SizedBox(height: 8),
              magicButton(
                Icons.music_note,
                item['songName'] == null
                    ? 'Büyülü Melodi Ekle'
                    : 'Melodi: ${item['songName']}',
                pickSong,
              ),
              if (item['songName'] != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: magicButton(
                        Icons.play_arrow,
                        'Çal',
                        playSong,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: magicButton(
                        Icons.stop,
                        'Durdur',
                        stopSong,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                magicButton(Icons.delete, 'Melodiyi Kaldır', removeSong),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(
                  text: item['text'].toString(),
                )..selection = TextSelection.fromPosition(
                    TextPosition(
                      offset: item['text'].toString().length,
                    ),
                  ),
                onChanged: (value) {
                  pages[currentPage]['text'] = value;
                },
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Bu büyülü sayfaya içinden geçenleri yaz...',
                  filled: true,
                  fillColor: Color(0xFFFFF8E1),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Text(statusText),
              const SizedBox(height: 8),
              magicButton(
                isListening ? Icons.stop : Icons.mic,
                isListening ? 'Dinlemeyi Durdur' : '🎙 Konuşarak Yaz',
                isListening ? stopListening : startListening,
              ),
              const SizedBox(height: 8),
              magicButton(
                Icons.auto_awesome,
                '🪄 Yaşadıklarımı Resmet',
                createMagicImageText,
              ),
              const SizedBox(height: 8),
              magicButton(
                Icons.smart_toy,
                '🤖 Günlüğümü Analiz Et',
                analyzeJournal,
              ),
              if (item['magicImageText'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECB3),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF6D4C41),
                    ),
                  ),
                  child: Text(
                    item['magicImageText'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                ),
              ],
              if (item['aiAnalysis'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    item['aiAnalysis'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              magicButton(Icons.save, 'Kaydet', savePage),
              const SizedBox(height: 8),
              magicButton(Icons.list, 'Günlüklerime Dön', openList),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showCover) return buildCover();
    if (showList) return buildList();
    return buildDetail();
  }
}
