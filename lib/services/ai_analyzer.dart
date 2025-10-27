import 'dart:io';
// For demo, this analyzer returns simulated labels.
// Replace with real TFLite inference using tflite_flutter for production.
class PlantAIAnalyzer {
  Future<void> initModel() async {
    // load TFLite model if available (not implemented in stub)
  }

  Future<String> analyze(File imageFile) async {
    final results = ['Sehat', 'Menguning', 'Busuk', 'Kering', 'Bercak'];
    results.shuffle();
    return results.first;
  }
}
