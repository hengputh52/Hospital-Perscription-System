import '../domain/medication.dart';
import 'json_storage_helper.dart';
import 'dart:io';

class MedicationRepository {
    String get filePath {
    final candidates = [
      'code/lib/data/medications.json',
      'lib/data/medications.json',
      'data/medications.json',
    ];
    for (final p in candidates) {
      if (File(p).existsSync()) return p;
    }
    const defaultPath = 'code/lib/data/medications.json';
    final dir = File(defaultPath).parent;
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return defaultPath;
  }

  List<Medication> getAll() {
    final data = JsonStorageHelper.readJsonList(filePath);
    return data.map((e) => Medication.fromJson(e)).toList();
  }

  void add(Medication medication) {
    final meds = getAll();
    meds.add(medication);
    JsonStorageHelper.writeJsonList(filePath, meds.map((e) => e.toJson()).toList());
  }

  Medication? findById(String id) {
    try {
      return getAll().firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
