import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalysisScreen extends StatefulWidget {
  final String languageCode;

  const AnalysisScreen({
    super.key,
    this.languageCode = 'tr',
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String selectedMode = 'emotionMap';
  String selectedEmotion = 'calm';
  Color selectedColor = const Color(0xFF5D4037);
  double strokeWidth = 5;

  final List<DrawingPoint?> points = [];

  bool get isEn => widget.languageCode == 'en';

  String t(String tr, String en) => isEn ? en : tr;

  final List<Map<String, String>> modes = [
    {'key': 'emotionMap', 'tr': 'Duygu Haritam', 'en': 'Emotion Map'},
    {'key': 'pencil', 'tr': 'Kara Kalem', 'en': 'Pencil Sketch'},
    {'key': 'stone', 'tr': 'Taş Boyama', 'en': 'Stone Painting'},
  ];

  final List<Map<String, String>> emotions = [
    {'key': 'calm', 'tr': 'Sakin', 'en': 'Calm'},
    {'key': 'hurt', 'tr': 'Kırgın', 'en': 'Hurt'},
    {'key': 'anxious', 'tr': 'Kaygılı', 'en': 'Anxious'},
    {'key': 'hopeful', 'tr': 'Umutlu', 'en': 'Hopeful'},
    {'key': 'tired', 'tr': 'Yorgun', 'en': 'Tired'},
    {'key': 'angry', 'tr': 'Öfkeli', 'en': 'Angry'},
  ];

  final List<Color> colorPalette = [
    Colors.black,
    Colors.grey,
    Colors.brown,
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.purple,
    Colors.pink,
  ];

  String modeName(String key) {
    final item = modes.firstWhere((e) => e['key'] == key);
    return isEn ? item['en']! : item['tr']!;
  }

  String emotionName(String key) {
    final item = emotions.firstWhere((e) => e['key'] == key);
    return isEn ? item['en']! : item['tr']!;
  }

  void clearCanvas() {
    setState(() => points.clear());
  }

  void setMode(String modeKey) {
    setState(() {
      selectedMode = modeKey;
      points.clear();

      if (modeKey == 'pencil') {
        selectedColor = Colors.black;
        strokeWidth = 4;
      } else if (modeKey == 'stone') {
        selectedColor = Colors.brown;
        strokeWidth = 6;
      } else {
        selectedColor = const Color(0xFF5D4037);
        strokeWidth = 5;
      }
    });
  }

  Color getModeColor() {
    if (selectedMode == 'pencil') return Colors.grey.shade800;
    if (selectedMode == 'stone') return Colors.brown;
    return const Color(0xFF8D6E63);
  }

  Future<void> saveDrawing() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('saved_drawings') ?? [];

    final data = {
      'mode': selectedMode,
      'emotion': selectedEmotion,
      'date': DateTime.now().toIso8601String(),
      'points': points.map((p) {
        if (p == null) return null;

        return {
          'dx': p.offset.dx,
          'dy': p.offset.dy,
          'color': p.paint.color.value,
          'strokeWidth': p.paint.strokeWidth,
        };
      }).toList(),
    };

    savedList.add(jsonEncode(data));
    await prefs.setStringList('saved_drawings', savedList);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t('Çizim kaydedildi', 'Drawing saved'))),
    );
  }

  Future<void> showSavedDrawings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('saved_drawings') ?? [];

    if (!mounted) return;

    if (savedList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('Henüz kayıtlı çizim yok', 'No saved drawings yet')),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: savedList.length,
          itemBuilder: (context, index) {
            final data = jsonDecode(savedList[index]);
            final date = DateTime.parse(data['date']);

            final title =
                '${modeName(data['mode'])} - ${emotionName(data['emotion'])} / ${date.day}.${date.month}.${date.year}';

            return ListTile(
              leading: const Icon(Icons.image),
              title: Text(title),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                loadDrawing(data);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void loadDrawing(Map<String, dynamic> data) {
    final loadedPoints = <DrawingPoint?>[];

    for (final item in data['points']) {
      if (item == null) {
        loadedPoints.add(null);
      } else {
        loadedPoints.add(
          DrawingPoint(
            Offset(
              (item['dx'] as num).toDouble(),
              (item['dy'] as num).toDouble(),
            ),
            Paint()
              ..color = Color(item['color'])
              ..strokeWidth = (item['strokeWidth'] as num).toDouble()
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round,
          ),
        );
      }
    }

    setState(() {
      selectedMode = data['mode'];
      selectedEmotion = data['emotion'];
      points
        ..clear()
        ..addAll(loadedPoints);
    });
  }

  @override
  Widget build(BuildContext context) {
    final modeColor = getModeColor();

    return Scaffold(
      backgroundColor: const Color(0xFF2B1A12),
      appBar: AppBar(
        title: Text(t('İçsel Sanat Defterim', 'My Inner Art Journal')),
        centerTitle: true,
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: const Color(0xFFFFECB3),
      ),
      body: Column(
        children: [
          const SizedBox(height: 6),
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: modes.length,
              itemBuilder: (context, index) {
                final mode = modes[index];
                final key = mode['key']!;
                final selected = selectedMode == key;

                return GestureDetector(
                  onTap: () => setMode(key),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: selected ? modeColor : const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: modeColor, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        modeName(key),
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: emotions.length,
              itemBuilder: (context, index) {
                final emotion = emotions[index];
                final key = emotion['key']!;
                final selected = selectedEmotion == key;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedEmotion = key);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF6D4C41) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF6D4C41)),
                    ),
                    child: Center(
                      child: Text(
                        emotionName(key),
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 8, 10, 6),
              decoration: BoxDecoration(
                color: const Color(0xFF4E342E),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3E2723),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        bottomLeft: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        9,
                        (index) => Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7CCC8),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black45),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: modeColor, width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Stack(
                          children: [
                            CustomPaint(
                              painter: NotebookPaperPainter(),
                              child: const SizedBox.expand(),
                            ),
                            if (selectedMode == 'stone')
                              Center(
                                child: Container(
                                  width: 300,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD7CCC8),
                                    borderRadius: BorderRadius.circular(140),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 14,
                              left: 22,
                              child: Text(
                                '${modeName(selectedMode)}  •  ${emotionName(selectedEmotion)}',
                                style: TextStyle(
                                  color: modeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onPanStart: (details) {
                                  setState(() {
                                    points.add(
                                      DrawingPoint(
                                        details.localPosition,
                                        Paint()
                                          ..color = selectedColor
                                          ..strokeWidth = strokeWidth
                                          ..strokeCap = StrokeCap.round
                                          ..strokeJoin = StrokeJoin.round,
                                      ),
                                    );
                                  });
                                },
                                onPanUpdate: (details) {
                                  setState(() {
                                    points.add(
                                      DrawingPoint(
                                        details.localPosition,
                                        Paint()
                                          ..color = selectedColor
                                          ..strokeWidth = strokeWidth
                                          ..strokeCap = StrokeCap.round
                                          ..strokeJoin = StrokeJoin.round,
                                      ),
                                    );
                                  });
                                },
                                onPanEnd: (_) {
                                  setState(() => points.add(null));
                                },
                                child: CustomPaint(
                                  painter: DrawingPainter(points),
                                  child: Container(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: colorPalette.length,
              itemBuilder: (context, index) {
                final color = colorPalette[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                      strokeWidth = selectedMode == 'pencil' ? 4 : 6;
                    });
                  },
                  child: Container(
                    width: 34,
                    height: 34,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == color
                            ? Colors.white
                            : Colors.black26,
                        width: selectedColor == color ? 4 : 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedColor = const Color(0xFFFFF8E1);
                        strokeWidth = 22;
                      });
                    },
                    icon: const Icon(Icons.cleaning_services),
                    label: Text(t('Silgi', 'Eraser')),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        strokeWidth = selectedMode == 'pencil' ? 4 : 6;
                      });
                    },
                    icon: const Icon(Icons.brush),
                    label: Text(t('Fırça', 'Brush')),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: clearCanvas,
                    icon: const Icon(Icons.delete),
                    label: Text(t('Temizle', 'Clear')),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: saveDrawing,
                    icon: const Icon(Icons.save),
                    label: Text(t('Kaydet', 'Save')),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: showSavedDrawings,
                    icon: const Icon(Icons.folder),
                    label: Text(t('Kayıtlar', 'Saved')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint(this.offset, this.paint);
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (current != null && next != null) {
        canvas.drawLine(current.offset, next.offset, current.paint);
      } else if (current != null && next == null) {
        canvas.drawCircle(
          current.offset,
          current.paint.strokeWidth / 2,
          current.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) => true;
}

class NotebookPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFFF8E1);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant NotebookPaperPainter oldDelegate) => false;
}
