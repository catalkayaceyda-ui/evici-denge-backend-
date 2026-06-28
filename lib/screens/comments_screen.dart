import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CommentsScreen extends StatefulWidget {
  final String languageCode;

  const CommentsScreen({
    super.key,
    this.languageCode = 'tr',
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  Uint8List? profileImage;
  Uint8List? postImage;

  String selectedTest = 'motherInLaw';
  String selectedFilter = 'all';

  final List<Map<String, String>> tests = [
    {
      'key': 'motherInLaw',
      'tr': 'Kaynanamla İlişkim',
      'en': 'My Relationship with My Mother-in-law'
    },
    {
      'key': 'spouse',
      'tr': 'Eşimle İlişkim',
      'en': 'My Relationship with My Spouse'
    },
    {'key': 'brideGuide', 'tr': 'Gelin Rehberi', 'en': 'Bride Guide'},
    {
      'key': 'sisterInLaw',
      'tr': 'Görümce İlişkileri',
      'en': 'Sister-in-law Relations'
    },
    {
      'key': 'coSisterInLaw',
      'tr': 'Elti İlişkileri',
      'en': 'Co-sister Relations'
    },
    {
      'key': 'children',
      'tr': 'Çocuklarla İletişim',
      'en': 'Communication with Children'
    },
    {'key': 'family', 'tr': 'Aile İçi Denge', 'en': 'Family Balance'},
  ];

  final List<Map<String, dynamic>> posts = [];

  bool get isEn => widget.languageCode == 'en';

  String t(String tr, String en) {
    return isEn ? en : tr;
  }

  String testName(String key) {
    final item = tests.firstWhere(
      (test) => test['key'] == key,
      orElse: () => tests.first,
    );

    return isEn ? item['en']! : item['tr']!;
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      profileImage = bytes;
    });
  }

  Future<void> pickPostImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      postImage = bytes;
    });
  }

  void sharePost() {
    final nickname = nicknameController.text.trim();
    final result = resultController.text.trim();
    final comment = commentController.text.trim();

    if (nickname.isEmpty || result.isEmpty || comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t('Lütfen tüm alanları doldur', 'Please fill in all fields'),
          ),
        ),
      );
      return;
    }

    setState(() {
      posts.insert(0, {
        'nickname': nickname,
        'testKey': selectedTest,
        'result': result,
        'comment': comment,
        'profileImage': profileImage,
        'postImage': postImage,
        'likes': 0,
        'liked': false,
        'replies': <String>[],
        'date': DateTime.now(),
      });

      resultController.clear();
      commentController.clear();
      postImage = null;
    });
  }

  void toggleLike(int index) {
    setState(() {
      final post = posts[index];

      if (post['liked'] == true) {
        post['likes']--;
        post['liked'] = false;
      } else {
        post['likes']++;
        post['liked'] = true;
      }
    });
  }

  void addReply(int index) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t('Yanıt yaz', 'Write a Reply')),
        content: TextField(
          controller: replyController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: t('Cevabını yaz...', 'Write your reply...'),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('İptal', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final reply = replyController.text.trim();

              if (reply.isNotEmpty) {
                setState(() {
                  posts[index]['replies'].add(reply);
                });
              }

              Navigator.pop(context);
            },
            child: Text(t('Gönder', 'Send')),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get filteredPosts {
    if (selectedFilter == 'all') return posts;

    return posts.where((post) => post['testKey'] == selectedFilter).toList();
  }

  @override
  void dispose() {
    nicknameController.dispose();
    resultController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F0),
      appBar: AppBar(
        title: Text(t('💬 Test Paylaşımları', '💬 Test Shares')),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: GestureDetector(
              onTap: pickProfileImage,
              child: CircleAvatar(
                radius: 42,
                backgroundColor: Colors.brown.shade100,
                backgroundImage:
                    profileImage != null ? MemoryImage(profileImage!) : null,
                child: profileImage == null
                    ? const Icon(Icons.camera_alt, size: 34)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              t('Profil fotoğrafı ekle', 'Add Profile Photo'),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: nicknameController,
            decoration: InputDecoration(
              labelText: t('Takma ad', 'Nickname'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedTest,
            decoration: InputDecoration(
              labelText: t('Hangi test?', 'Which Test?'),
              border: const OutlineInputBorder(),
            ),
            items: tests.map((test) {
              final key = test['key']!;
              return DropdownMenuItem(
                value: key,
                child: Text(testName(key)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTest = value!;
              });
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: resultController,
            decoration: InputDecoration(
              labelText: t('Test sonucunu yaz', 'Write Your Test Result'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: commentController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: t('Yorumun', 'Your Comment'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          if (postImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                postImage!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: pickPostImage,
                  icon: const Icon(Icons.image),
                  label: Text(t('Fotoğraf Ekle', 'Add Photo')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: sharePost,
                  icon: const Icon(Icons.send),
                  label: Text(t('Paylaş', 'Share')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            value: selectedFilter,
            decoration: InputDecoration(
              labelText: t('Paylaşımları filtrele', 'Filter Posts'),
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: 'all',
                child: Text(t('Tümü', 'All')),
              ),
              ...tests.map((test) {
                final key = test['key']!;
                return DropdownMenuItem(
                  value: key,
                  child: Text(testName(key)),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                selectedFilter = value!;
              });
            },
          ),
          const SizedBox(height: 18),
          if (filteredPosts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  t(
                    'Henüz paylaşım yok.\nİlk paylaşımı sen yap.',
                    'No posts yet.\nBe the first to share.',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ...filteredPosts.asMap().entries.map((entry) {
            final index = posts.indexOf(entry.value);
            final post = entry.value;

            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: post['profileImage'] != null
                              ? MemoryImage(post['profileImage'])
                              : null,
                          child: post['profileImage'] == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            post['nickname'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      testName(post['testKey']),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text('${t('Sonuç', 'Result')}: ${post['result']}'),
                    const SizedBox(height: 6),
                    Text(post['comment']),
                    if (post['postImage'] != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          post['postImage'],
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => toggleLike(index),
                          icon: Icon(
                            post['liked'] == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: post['liked'] == true
                                ? Colors.red
                                : Colors.grey,
                          ),
                          label: Text('${post['likes']}'),
                        ),
                        TextButton.icon(
                          onPressed: () => addReply(index),
                          icon: const Icon(Icons.reply),
                          label: Text(t('Cevapla', 'Reply')),
                        ),
                      ],
                    ),
                    if (post['replies'].isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t('Cevaplar', 'Replies'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...post['replies'].map<Widget>((reply) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text('• $reply'),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
