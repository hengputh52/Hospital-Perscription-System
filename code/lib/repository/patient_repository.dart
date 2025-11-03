import '../domain/patient.dart';
import 'json_storage_helper.dart';
import 'dart:io';

class PatientRepository {
    String get filePath {
    final candidates = [
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
    return data.map((e) => Patient.fromJson(e)).toList();
  }

  void add(Patient patient) {
    final patients = getAll();
    patients.add(patient);
    JsonStorageHelper.writeJsonList(filePath, patients.map((e) => e.toJson()).toList());
  }

  Patient? findById(String id) {
    try {
      return getAll().firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
