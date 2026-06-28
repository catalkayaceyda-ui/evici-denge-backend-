import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final String languageCode;
  final void Function(Color color, ThemeMode mode) onThemeChanged;
  final void Function(String code) onLanguageChanged;

  const SplashScreen({
    super.key,
    required this.languageCode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  bool get isEn => widget.languageCode == 'en';

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(controller);

    scaleAnimation = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
    );

    controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            onThemeChanged: widget.onThemeChanged,
            languageCode: widget.languageCode,
            onLanguageChanged: widget.onLanguageChanged,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F0),
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Image.asset(
                      'assets/icon/app_icon.png',
                      width: 185,
                      height: 185,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Ev İçi Denge',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7E57C2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isEn
                        ? 'Family peace, balanced relationships.'
                        : 'Ailede huzur, ilişkilerde denge.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    isEn
                        ? 'AI-Powered Family Guide'
                        : 'Yapay zekâ destekli aile rehberi',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                  const SizedBox(height: 38),
                  const SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFF9C6ADE),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
