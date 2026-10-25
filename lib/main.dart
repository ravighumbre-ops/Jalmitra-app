
import 'package:flutter/material.dart';

void main() {
  runApp(const JalmitraApp());
}

class JalmitraApp extends StatelessWidget {
  const JalmitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jalmitra',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const JalmitraHome(),
    );
  }
}

class JalmitraHome extends StatelessWidget {
  const JalmitraHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jalmitra - भूजल माहिती'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(
            Icons.water_drop,
            size: 70,
            color: Colors.blue,
          ),
          const Text(
            'वाघाळा, ता. पाथरी, जि. परभणी',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.map),
              title: const Text('भूजल संभाव्यता नकाशा'),
              subtitle: const Text(
                'अधिकृत नकाशा जोडण्याचे काम बाकी आहे.',
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.water),
              title: const Text('विहीर नियोजन'),
              subtitle: const Text(
                'भूजल माहिती व स्थानिक सर्वेक्षण आवश्यक.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'सूचना: हा प्राथमिक नमुना आहे. '
            'यामध्ये प्रत्यक्ष भूजल मोजमाप किंवा '
            'पाणी मिळण्याची खात्री दिलेली नाही.',
          ),
        ],
      ),
    );
  }
}
