import 'package:flutter/material.dart';

class Day3Screen extends StatelessWidget {
  const Day3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 3: Your First Flutter App'),
        backgroundColor: const Color(0xFFd2604f),
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day 3: Your First Flutter App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFd2604f),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Creating Your First App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Hari ini kita akan membuat aplikasi Flutter pertama dengan struktur dasar dan widget sederhana.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Struktur Project Flutter:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '• lib/ - kode Dart utama\n• android/ - konfigurasi Android\n• ios/ - konfigurasi iOS\n• pubspec.yaml - dependencies\n• main.dart - entry point aplikasi',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Basic App Structure:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'void main() {\n  runApp(MyApp());\n}\n\nclass MyApp extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      home: Scaffold(\n        appBar: AppBar(title: Text("Hello")),\n        body: Text("Hello World!"),\n      ),\n    );\n  }\n}',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                backgroundColor: Color(0xFFF5F5F5),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Yang dipelajari hari ini:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '1. Struktur project Flutter\n2. main.dart dan runApp()\n3. MaterialApp widget\n4. Scaffold widget\n5. Hot reload',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
