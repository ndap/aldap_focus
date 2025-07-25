import 'package:flutter/material.dart';

class Day2Screen extends StatelessWidget {
  const Day2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 2: Dart Programming Basics'),
        backgroundColor: const Color(0xFFd2604f),
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day 2: Dart Programming Basics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFd2604f),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Dart Language Fundamentals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Dart adalah bahasa pemrograman yang digunakan Flutter. Dart adalah bahasa yang mudah dipelajari dengan syntax yang familiar.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Dart Data Types:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '• int - bilangan bulat\n• double - bilangan desimal\n• String - teks\n• bool - true/false\n• List - array/daftar\n• Map - key-value pairs',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Variables & Functions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'var name = "Flutter";\nint age = 5;\nString getName() {\n  return name;\n}',
              style: TextStyle(
                fontSize: 14,
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
              '1. Dart syntax dasar\n2. Data types\n3. Variables dan constants\n4. Functions\n5. Control flow (if, for, while)',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
