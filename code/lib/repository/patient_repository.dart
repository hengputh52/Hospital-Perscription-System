import '../domain/patient.dart';
import 'json_storage_helper.dart';
import 'dart:io';

class PatientRepository {
  String get filePath {
    final candidates = [
       'Hospital-Perscription-System/code/lib/data/patients.json',
      'code/lib/data/patients.json',
      'lib/data/patients.json',
      'data/patients.json',
    ];
    for (final p in candidates) {
      if (File(p).existsSync()) return p;
    }
    const defaultPath = 'code/lib/data/patients.json';
    final dir = File(defaultPath).parent;
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return defaultPath;
  }

  List<Patient> getAll() {
    final data = JsonStorageHelper.readJsonList(filePath);
    final maps = data.whereType<Map<String, dynamic>>();
    return maps.map((e) => Patient.fromJson(e)).toList();
  }

  void add(Patient p) {
    final map = getAll();
    final idx = map.indexWhere((e) => e.id == p.id);
    if (idx >= 0) map[idx] = p;
    else map.add(p);
    JsonStorageHelper.writeJsonList(filePath, map.map((e) => e.toJson()).toList());
  }

  /// Delete patient by id. Returns true if deleted.
  bool deleteById(String id) {
    final patients = getAll();
    final initialLen = patients.length;
    final remaining = patients.where((p) => p.id != id).toList();
    if (remaining.length == initialLen) return false;
    JsonStorageHelper.writeJsonList(filePath, remaining.map((e) => e.toJson()).toList());
    return true;
  }

  Patient? findById(String id) {
    try {
      return getAll().firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
