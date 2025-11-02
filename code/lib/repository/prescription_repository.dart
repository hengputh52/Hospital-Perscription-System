import '../domain/prescription.dart';
import 'json_storage_helper.dart';

class PrescriptionRepository {
  final String filePath = '../data/prescriptions.json';

  List<Prescription> getAll() {
    final data = JsonStorageHelper.readJsonList(filePath);
    return data.map((e) => Prescription.fromJson(e)).toList();
  }

  void add(Prescription prescription) {
    final prescriptions = getAll();
    prescriptions.add(prescription);
    JsonStorageHelper.writeJsonList(filePath, prescriptions.map((e) => e.toJson()).toList());
  }

  List<Prescription> getByPatientId(String patientId) {
    return getAll().where((p) => p.patient_id == patientId).toList();
  }

  Prescription? findById(String id) {
    try {
      return getAll().firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
