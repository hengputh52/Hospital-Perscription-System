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
    final maps = data.whereType<Map<String, dynamic>>();
    return maps.map((e) => MedicalLog.fromJson(e)).toList();
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

  // AI-generated
  bool deleteById(String logId) {
    final logs = getAll();
    final initialLen = logs.length;
    final remaining = logs.where((l) => l.log_id != logId).toList();
    if (remaining.length == initialLen) return false;
    JsonStorageHelper.writeJsonList(filePath, remaining.map((e) => e.toJson()).toList());
    return true;
  }

  /// Delete all logs for a given prescription id. Returns number deleted.
  int deleteByPrescriptionId(String prescriptionId) {
    final logs = getAll();
    final remaining = logs.where((l) => l.prescription_id != prescriptionId).toList();
    final deleted = logs.length - remaining.length;
    if (deleted > 0) {
      JsonStorageHelper.writeJsonList(filePath, remaining.map((e) => e.toJson()).toList());
    }
    return deleted;
  }
}
