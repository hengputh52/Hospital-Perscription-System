import '../domain/prescription.dart';
import 'json_storage_helper.dart';
import 'dart:io';

class PrescriptionRepository {
  String get filePath {
    final candidates = [
      'code/lib/data/prescriptions.json',
      'lib/data/prescriptions.json',
      'data/prescriptions.json',
    ];
    for (final p in candidates) {
      if (File(p).existsSync()) return p;
    }
    const defaultPath = 'code/lib/data/prescriptions.json';
    final dir = File(defaultPath).parent;
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return defaultPath;
  }

  List<Prescription> getAll() {
    final data = JsonStorageHelper.readJsonList(filePath);
    return data.map((e) => Prescription.fromJson(e)).toList();
  }

  void add(Prescription prescription) {
    final prescriptions = getAll();
    prescriptions.add(prescription);
    JsonStorageHelper.writeJsonList(filePath, prescriptions.map((e) => e.toJson()).toList());
  }

    void update(Prescription prescription) {
    final prescriptions = getAll();
    final index = prescriptions.indexWhere((p) => p.id == prescription.id);
    if (index >= 0) {
      prescriptions[index] = prescription;
    } else {
      prescriptions.add(prescription);
    }
    JsonStorageHelper.writeJsonList(filePath, prescriptions.map((e) => e.toJson()).toList());
  }

  List<Prescription> getByPatientId(String patientId) {
    final found = getAll().where((p) => p.patient_id == patientId).toList();
    if(found.isEmpty)
    {
      throw StateError("No prescription for this patientID");
    }
    return found;
  }

  Prescription? findById(String id) {
    try {
      return getAll().firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
