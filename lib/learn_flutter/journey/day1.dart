import 'package:flutter/material.dart';

class Day1Screen extends StatelessWidget {
  const Day1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 1: Introduction to Flutter'),
        backgroundColor: const Color(0xFFd2604f),
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day 1: Introduction to Flutter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFd2604f),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to Flutter!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Flutter adalah framework UI toolkit dari Google untuk membangun aplikasi yang dikompilasi secara native untuk mobile, web, dan desktop dari satu codebase.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Mengapa Flutter?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '• Cross-platform development\n• Fast development dengan Hot Reload\n• Native performance\n• Rich widget library\n• Strong community support\n• Backed by Google',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Arsitektur Flutter:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Flutter menggunakan Dart sebagai bahasa pemrograman dan memiliki arsitektur berlapis:\n\n1. Framework Layer (Dart)\n2. Engine Layer (C/C++)\n3. Embedder Layer (Platform-specific)',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Yang dipelajari hari ini:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '1. Apa itu Flutter\n2. Keunggulan Flutter\n3. Arsitektur Flutter\n4. Setup development environment\n5. Membuat project Flutter pertama',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Next: Day 2 - Dart Programming Basics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFd2604f),
              ),
            ),
          ],
        ),
      ),
    );
  }
}