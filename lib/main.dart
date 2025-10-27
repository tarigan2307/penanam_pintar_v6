import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penanam_pintar_v6/services/drive_service.dart';
import 'package:penanam_pintar_v6/services/ai_analyzer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penanam Pintar v6',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  final DriveService _drive = DriveService();
  final PlantAIAnalyzer _analyzer = PlantAIAnalyzer();
  String _lastResult = '';

  @override
  void initState() {
    super.initState();
    _drive.signInSilently(); // try silent sign-in
    _analyzer.initModel(); // prepare local model (placeholder)
  }

  Future<void> _takePhotoAndUpload() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked == null) return;
    final file = File(picked.path);

    // Run local analysis (if model present)
    final result = await _analyzer.analyze(file);
    setState(() { _lastResult = result; });

    // Auto-upload to Google Drive (appDataFolder)
    await _drive.uploadFile(file);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Foto tersimpan dan diunggah. Analisis: $result')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penanam Pintar v6')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Tekan tombol kamera untuk mengambil foto tanaman. Foto akan otomatis dianalisis dan diunggah ke Google Drive.'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil Foto (Auto-Upload)'),
              onPressed: _takePhotoAndUpload,
            ),
            const SizedBox(height: 20),
            Text('Hasil analisis terakhir: $_lastResult'),
          ],
        ),
      ),
    );
  }
}
