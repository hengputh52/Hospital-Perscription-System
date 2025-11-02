import 'ui/doctor_ui.dart';
import 'ui/patient_ui.dart';
import 'repository/prescription_repository.dart';
import 'repository/medical_log_repository.dart';
import 'repository/medication_repository.dart';
import 'dart:io';

void main() {
  final prescriptionRepo = PrescriptionRepository();
  final medicationRepo = MedicationRepository();
  final medicalLogRepo = MedicalLogRepository();

  final doctorUI = DoctorUI(prescriptionRepo, medicationRepo);
  final patientUI = PatientUI(medicalLogRepo);

  print("Choose role: 1 = Doctor, 2 = Patient");
  final role = int.parse(stdin.readLineSync()!);




  if (role == 1) {
    print("Enter doctorId and patientId:");
    final doctorId = stdin.readLineSync()!;
    final patientId = stdin.readLineSync()!;
    doctorUI.createPrescription(doctorId, patientId);
  } else {
    print("Enter prescriptionId, patientId, medicationId, and mark (1 = taken, 0 = missed):");
    final pid = stdin.readLineSync()!;
    final patId = stdin.readLineSync()!;
    final medId = stdin.readLineSync()!;
    final mark = int.parse(stdin.readLineSync()!);
    patientUI.markMedication(pid, patId, medId, mark == 1);
  }


}
