import '../domain/medical_log.dart';
import 'json_storage_helper.dart';
import 'dart:io';

class MedicalLogRepository {
    String get filePath {
    final candidates = [
      'code/lib/data/medical_logs.json',
      'lib/data/medical_logs.json',
      'data/medical_logs.json',
    ];
    for (final p in candidates) {
      if (File(p).existsSync()) return p;
    }
    const defaultPath = 'code/lib/data/medical_logs.json';
    final dir = File(defaultPath).parent;
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return defaultPath;
  }

  List<MedicalLog> getAll() {
    final data = JsonStorageHelper.readJsonList(filePath);
    return data.map((e) => MedicalLog.fromJson(e)).toList();
  }

  void add(MedicalLog log) {
    final logs = getAll();
    logs.add(log);
    JsonStorageHelper.writeJsonList(filePath, logs.map((e) => e.toJson()).toList());
  }

  List<MedicalLog> getByPatient(String patientId) {
    return getAll().where((l) => l.patient_id == patientId).toList();
  }

  List<MedicalLog> getByPrescription(String prescriptionId) {
    return getAll().where((l) => l.prescription_id == prescriptionId).toList();
  }
}
