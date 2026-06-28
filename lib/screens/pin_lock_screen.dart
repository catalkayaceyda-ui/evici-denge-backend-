import 'package:flutter/material.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final TextEditingController pinController = TextEditingController();

  String? createdPin;
  bool isPinCreated = false;

  void createPin() {
    if (pinController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN 4 haneli olmalı')),
      );
      return;
    }

    setState(() {
      createdPin = pinController.text;
      isPinCreated = true;
      pinController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN oluşturuldu. Şimdi PIN girip aç.')),
    );
  }

  void unlockPin() {
    if (!isPinCreated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Önce PIN oluşturmalısın')),
      );
      return;
    }

    if (pinController.text == createdPin) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hatalı PIN')),
      );
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔒 Günlük Kilidi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPinCreated ? Icons.lock : Icons.lock_open,
              size: 70,
              color: isPinCreated ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              isPinCreated ? 'PIN Kodunu Gir' : 'Önce PIN Oluştur',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '4 Haneli PIN',
              ),
            ),
            const SizedBox(height: 20),
            if (!isPinCreated)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: createPin,
                  icon: const Icon(Icons.add),
                  label: const Text('PIN Oluştur'),
                ),
              ),
            if (isPinCreated)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: unlockPin,
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Kilidi Aç'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
