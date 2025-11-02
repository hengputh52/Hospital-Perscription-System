import '../domain/medication.dart';
import 'json_storage_helper.dart';

class MedicationRepository {
  final String filePath = 'data/medications.json';

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
