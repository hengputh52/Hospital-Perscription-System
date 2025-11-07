import '../domain/medication.dart';
import 'json_storage_helper.dart';
import 'dart:io';

class MedicationRepository {
    String get filePath {
    final candidates = [
       'Hospital-Perscription-System/code/lib/data/medications.json',
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

  void saveAll(List<Medication> meds) {
    JsonStorageHelper.writeJsonList(
      filePath,
      meds.map((m) => m.toJson()).toList(),
    );
  }

  void addMedication(Medication med) {
    final meds = getAll();
    final index = meds.indexWhere((m) => m.id == med.id);
    if (index >= 0) meds[index] = med;
    else meds.add(med);
    saveAll(meds);
  }

    bool deleteById(String id) {
    final meds = getAll();
    final initialLen = meds.length;
    final remaining = meds.where((m) => m.id != id).toList();
    if (remaining.length == initialLen) return false;
    saveAll(remaining);
    return true;
  }

  Medication? findById(String id) {
    try {
      return getAll().firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
