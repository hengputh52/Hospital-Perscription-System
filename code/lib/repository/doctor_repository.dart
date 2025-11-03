import 'dart:io';
import '../domain/doctor.dart';
import 'json_storage_helper.dart';

class DoctorRepository {
  String get filePath {
    final candidates = [
      'code/lib/data/doctors.json',
      'lib/data/doctors.json',
      'data/doctors.json',
    ];
    for (final p in candidates) {
      if (File(p).existsSync()) return p;
    }
    const defaultPath = 'code/lib/data/doctors.json';
    final dir = File(defaultPath).parent;
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return defaultPath;
  }

  List<Doctor> getAll() {
    final data = JsonStorageHelper.readJsonList(filePath);
    // ignore non-map entries and be defensive about malformed JSON entries
    final maps = data.whereType<Map<String, dynamic>>();
    return maps.map((e) => Doctor.fromJson(e)).toList();
  }

  void add(Doctor doctor) {
    final doctors = getAll();
    final index = doctors.indexWhere((d) => d.id == doctor.id);
    if (index >= 0) {
      doctors[index] = doctor;
    } else {
      doctors.add(doctor);
    }
    JsonStorageHelper.writeJsonList(filePath, doctors.map((e) => e.toJson()).toList());
  }
  

  Doctor? findById(String id) {
    try {
      return getAll().firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}
