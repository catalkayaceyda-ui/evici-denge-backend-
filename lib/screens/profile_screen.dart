import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String selectedAvatar = '🌸';

  final List<String> avatars = [
    '🌸',
    '🌙',
    '🦋',
    '💜',
    '🌿',
    '☀️',
    '⭐',
    '💎',
    '🕊️',
    '🎨',
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      selectedAvatar = prefs.getString('profile_avatar') ?? '🌸';
      nicknameController.text = prefs.getString('profile_nickname') ?? '';
      bioController.text = prefs.getString('profile_bio') ?? '';
    });
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('profile_avatar', selectedAvatar);
    await prefs.setString('profile_nickname', nicknameController.text.trim());
    await prefs.setString('profile_bio', bioController.text.trim());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil kaydedildi')),
    );
  }

  @override
  void dispose() {
    nicknameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F8),
      appBar: AppBar(
        title: const Text('Profilim'),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF80AB),
                    Color(0xFF7E57C2),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  selectedAvatar,
                  style: const TextStyle(fontSize: 58),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Avatar Seç',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: avatars.map((avatar) {
              final selected = selectedAvatar == avatar;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = avatar;
                  });
                },
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFE91E63) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? const Color(0xFFE91E63) : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      avatar,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nicknameController,
            decoration: InputDecoration(
              labelText: 'Takma ad',
              prefixIcon: const Icon(Icons.person),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: bioController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Kendini kısaca anlat',
              prefixIcon: const Icon(Icons.edit_note),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: saveProfile,
            icon: const Icon(Icons.save),
            label: const Text('Profili Kaydet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
