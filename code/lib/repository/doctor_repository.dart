import '../domain/doctor.dart';
import 'json_storage_helper.dart';

class DoctorRepository {
  final String filePath = 'data/doctors.json';

  List<Doctor> getAll() {
    final data = JsonStorageHelper.readJsonList(filePath);
    return data.map((e) => Doctor.fromJson(e)).toList();
  }

  void add(Doctor doctor) {
    final doctors = getAll();
    doctors.add(doctor);
    JsonStorageHelper.writeJsonList(filePath, doctors.map((e) => e.toJson()).toList());
  }

  Doctor? findById(String id) {
    return getAll().firstWhere((d) => d.id == id, orElse: () => Doctor(firstName: '', lastName: '', specialization: ''));
  }
}
