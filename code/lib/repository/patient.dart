import '../domain/patient.dart';
import 'json_storage_helper.dart';

class PatientRepository {
  final String filePath = 'data/patients.json';

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
