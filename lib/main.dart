import 'package:flutter/material.dart';

void main() {
  runApp(const PenanamPintarApp());
}

class PenanamPintarApp extends StatelessWidget {
  const PenanamPintarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penanam Pintar v6',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penanam Pintar v6')),
      body: const Center(
        child: Text(
          'Aplikasi Pemupukan Cerdas (AI + Google Drive)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
