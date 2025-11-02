import '../domain/medical_log.dart';
import 'json_storage_helper.dart';

class MedicalLogRepository {
  final String filePath = 'data/medical_logs.json';

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
