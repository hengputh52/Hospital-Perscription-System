import 'dart:convert';
import 'dart:io';

class JsonStorageHelper {
  // AI-generated
  static List<Map<String, dynamic>> readJsonList(String path) {
    final file = File(path);
    if (!file.existsSync()) return [];
    final content = file.readAsStringSync();
    if (content.trim().isEmpty) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(content));
  }

  static void writeJsonList(String path, List<Map<String, dynamic>> data) {
    final file = File(path);
    file.createSync(recursive: true);
    file.writeAsStringSync(jsonEncode(data), flush: true);
  }
}

