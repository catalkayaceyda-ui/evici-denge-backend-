import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';

class MagicJournalDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? existingJournal;
  final int? reversedIndex;
  final String languageCode;

  const MagicJournalDetailScreen({
    super.key,
    this.existingJournal,
    this.reversedIndex,
    this.languageCode = 'tr',
  });

  @override
  State<MagicJournalDetailScreen> createState() =>
      _MagicJournalDetailScreenState();
}

class _MagicJournalDetailScreenState extends State<MagicJournalDetailScreen> {
  final ImagePicker imagePicker = ImagePicker();
  final AudioPlayer audioPlayer = AudioPlayer();
  final TextEditingController controller = TextEditingController();

  late stt.SpeechToText speech;

  bool isListening = false;
  bool isPlaying = false;

  String selectedEmoji = '😊';
  Uint8List? photo;
  String? magicResult;
  String? songName;
  Uint8List? songBytes;
  String? songPath;

  final List<String> emojis = ['😢', '😔', '😐', '😊', '😍', '😡', '😴', '🙏'];

  bool get isEn => widget.languageCode == 'en';

  String t(String tr, String en) {
    return isEn ? en : tr;
  }

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();

    final journal = widget.existingJournal;
    if (journal != null) {
      selectedEmoji = journal['emoji'] ?? '😊';
      controller.text = journal['text'] ?? '';
      magicResult = journal['analysis'];
    }
  }

  @override
  void dispose() {
    controller.dispose();
    audioPlayer.dispose();
    speech.stop();
    super.dispose();
  }

  String getDateText() {
    final now = DateTime.now();
    return '${now.day}.${now.month}.${now.year} - ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> saveJournal() async {
    final text = controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t(
              'Önce günlüğüne bir şeyler yaz.',
              'Write something in your journal first.',
            ),
          ),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('magic_journals') ?? [];

    final journal = {
      'emoji': selectedEmoji,
      'date': getDateText(),
      'text': text,
      'analysis': magicResult,
    };

    if (widget.reversedIndex != null) {
      final realIndex = savedList.length - 1 - widget.reversedIndex!;
      if (realIndex >= 0 && realIndex < savedList.length) {
        savedList[realIndex] = jsonEncode(journal);
      } else {
        savedList.add(jsonEncode(journal));
      }
    } else {
      savedList.add(jsonEncode(journal));
    }

    await prefs.setStringList('magic_journals', savedList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t('Günlük kaydedildi', 'Journal saved'),
        ),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> pickPhoto() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    setState(() => photo = bytes);
  }

  Future<void> pickMusic() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    setState(() {
      songName = file.name;
      songBytes = file.bytes;
      songPath = file.path;
    });
  }

  Future<void> playMusic() async {
    if (songBytes == null && songPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t('Önce müzik seç', 'Choose music first'),
          ),
        ),
      );
      return;
    }

    await audioPlayer.stop();

    if (songBytes != null) {
      await audioPlayer.play(BytesSource(songBytes!));
    } else if (songPath != null) {
      await audioPlayer.play(DeviceFileSource(songPath!));
    }

    setState(() => isPlaying = true);
  }

  Future<void> stopMusic() async {
    await audioPlayer.stop();
    setState(() => isPlaying = false);
  }

  Future<void> startListening() async {
    final available = await speech.initialize();

    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t('Mikrofon izni alınamadı',
                'Microphone permission could not be obtained'),
          ),
        ),
      );
      return;
    }

    setState(() => isListening = true);

    speech.listen(
      localeId: isEn ? 'en_US' : 'tr_TR',
      onResult: (result) {
        setState(() {
          controller.text = result.recognizedWords;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        });
      },
    );
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  void analyzeJournal() {
    final text = controller.text.trim();

    String result;

    if (text.isEmpty) {
      result = t(
        'Önce günlüğüne bir şeyler yaz.',
        'Write something in your journal first.',
      );
    } else if (selectedEmoji == '😢' || selectedEmoji == '😔') {
      result = t(
        '😔 Günlük Analizi\n\nBugün duygusal olarak yorgun görünüyorsun. Kendine biraz zaman ayırmak iyi gelebilir.',
        '😔 Journal Analysis\n\nYou seem emotionally tired today. Taking some time for yourself may help.',
      );
    } else if (selectedEmoji == '😊' || selectedEmoji == '😍') {
      result = t(
        '😊 Günlük Analizi\n\nBugün pozitif ve umutlu bir enerji taşıyorsun.',
        '😊 Journal Analysis\n\nYou seem to carry a positive and hopeful energy today.',
      );
    } else if (selectedEmoji == '😡') {
      result = t(
        '😡 Günlük Analizi\n\nYazında öfke ve gerginlik hissediliyor. Karar vermeden önce sakinleşmek faydalı olabilir.',
        '😡 Journal Analysis\n\nYour writing shows anger and tension. It may help to calm down before making a decision.',
      );
    } else if (selectedEmoji == '😴') {
      result = t(
        '😴 Günlük Analizi\n\nYorgunluk ve dinlenme ihtiyacı görünüyor. Bugün kendini zorlamadan küçük bir mola vermen iyi gelebilir.',
        '😴 Journal Analysis\n\nFatigue and a need for rest are visible. A small break without pushing yourself may help today.',
      );
    } else if (selectedEmoji == '🙏') {
      result = t(
        '🙏 Günlük Analizi\n\nİçsel sakinlik ve manevi destek arayışı hissediliyor. Sessiz kalmak, dua etmek veya derin nefes almak iyi gelebilir.',
        '🙏 Journal Analysis\n\nThere seems to be a search for inner calm and spiritual support. Silence, prayer, or deep breathing may help.',
      );
    } else {
      result = t(
        '🤖 Günlük Analizi\n\nYazdıkların üzerinde düşünmeye değer duygular içeriyor.',
        '🤖 Journal Analysis\n\nWhat you wrote contains emotions worth reflecting on.',
      );
    }

    setState(() {
      magicResult = result;
    });
  }

  void clearCurrentPage() {
    audioPlayer.stop();

    setState(() {
      controller.clear();
      selectedEmoji = '😊';
      photo = null;
      magicResult = null;
      songName = null;
      songBytes = null;
      songPath = null;
      isPlaying = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t('Sayfa temizlendi', 'Page cleared'),
        ),
      ),
    );
  }

  Widget sideButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.only(bottom: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF3E2723).withOpacity(0.88),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD7A64A)),
        ),
        child: Icon(icon, color: const Color(0xFFFFD54F), size: 20),
      ),
    );
  }

  Widget bottomButton(String text, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF3E2723).withOpacity(0.92),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFFFFD54F), size: 15),
              const SizedBox(width: 3),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFFFFECB3),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0F08),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 1200,
            height: 850,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/empty_journal.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 18,
                  left: 40,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF3E2723),
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 35,
                  left: 330,
                  right: 330,
                  child: Column(
                    children: [
                      Text(
                        t('Büyülü Günlük', 'Magic Journal'),
                        style: const TextStyle(
                          color: Color(0xFF3E2723),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(selectedEmoji, style: const TextStyle(fontSize: 30)),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 5,
                        children: emojis.map((emoji) {
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedEmoji = emoji);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: selectedEmoji == emoji
                                    ? const Color(0xFFFFECB3)
                                    : Colors.white.withOpacity(0.30),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 180,
                  left: 140,
                  width: 300,
                  height: 180,
                  child: TextField(
                    controller: controller,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: t(
                        'Bugün neler yaşadın...',
                        'What happened today...',
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Color(0xFF3E2723),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Positioned(
                  top: 550,
                  left: 155,
                  width: 320,
                  height: 220,
                  child: GestureDetector(
                    onTap: pickPhoto,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.30),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF8D6E63)),
                      ),
                      child: photo == null
                          ? Center(
                              child: Text(
                                t('📷 Fotoğraf Ekle', '📷 Add Photo'),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                photo!,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: 490,
                  left: 155,
                  width: 250,
                  height: 60,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF8D6E63)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.stop : Icons.play_arrow,
                            size: 20,
                          ),
                          onPressed: isPlaying ? stopMusic : playMusic,
                        ),
                        Expanded(
                          child: Text(
                            songName ??
                                t('🎵 Müzik seçilmedi', '🎵 No music selected'),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.music_note, size: 20),
                          onPressed: pickMusic,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 185,
                  right: 150,
                  width: 255,
                  height: 250,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF8D6E63)),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(
                          magicResult ??
                              t(
                                '🤖 Günlüğünü yaz ve soldaki robot ikonuna bas',
                                '🤖 Write in your journal and press the robot icon on the left',
                              ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF3E2723),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 210,
                  left: 58,
                  child: Column(
                    children: [
                      sideButton(Icons.edit, () {}),
                      sideButton(Icons.photo, pickPhoto),
                      sideButton(Icons.music_note, pickMusic),
                      sideButton(
                        isListening ? Icons.stop : Icons.mic,
                        isListening ? stopListening : startListening,
                      ),
                      sideButton(Icons.smart_toy, analyzeJournal),
                    ],
                  ),
                ),
                Positioned(
                  left: 145,
                  right: 145,
                  bottom: 45,
                  child: Row(
                    children: [
                      bottomButton(
                          t('Kaydet', 'Save'), Icons.save, saveJournal),
                      bottomButton(
                          t('Sil', 'Delete'), Icons.delete, clearCurrentPage),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
