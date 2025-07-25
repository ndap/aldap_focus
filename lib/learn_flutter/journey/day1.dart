import 'package:flutter/material.dart';

class Day1Screen extends StatelessWidget {
  const Day1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 1'),
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
              'What is Flutter?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Flutter adalah UI toolkit dari Google untuk membangun aplikasi yang dikompilasi secara native untuk mobile, web, dan desktop dari satu codebase.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Keunggulan Flutter:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '• Cross-platform development\n• Hot reload untuk development cepat\n• Performance tinggi\n• Rich widget library\n• Backed by Google',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Hari ini kita belajar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '1. Apa itu Flutter\n2. Mengapa memilih Flutter\n3. Arsitektur Flutter\n4. Setup development environment',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
