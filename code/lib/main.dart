import 'package:hospital_prescription_management/domain/medication.dart';
import 'package:hospital_prescription_management/repository/doctor_repository.dart';
import 'package:hospital_prescription_management/repository/patient_repository.dart';
import 'package:hospital_prescription_management/ui/pharmacist.dart';

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
  final doctorRepo = DoctorRepository();
  final patientRepo = PatientRepository();

  final doctorUI = DoctorUI(prescriptionRepo, medicationRepo, doctorRepo, patientRepo);
  final patientUI = PatientUI(medicalLogRepo, patientRepo, prescriptionRepo, medicationRepo);
  final pharmacistUI = PharmacistUI(medicationRepo);

  bool exitProgram = false;
  while (!exitProgram) {
    print("\n=== Hospital Prescription System ===");
    print("0. Exit");
    print("1. Doctor");
    print("2. Patient");
    print("3. Pharmacist (adding medication)");
    stdout.write("Choose your role (0-3): ");
    final role = int.parse(stdin.readLineSync()!);
    

    switch (role) {
      case 0:
        exitProgram = true;
        print("Exiting program.");
        break;

      case 1:
        // Doctor menu loop
        bool backToMain = false;
        while (!backToMain) {
          print("\n--- Doctor Menu ---");
          print("0. Back to role selection");
          print("1. Doctor sign up");
          print("2. Create prescription for patient");
          print("3. View all prescription ");
          print("4. View prescription by patientID");
          print("5. Update prescription");
          print("6. View medical log");
          stdout.write("Enter your choice: ");
          final choice = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
          switch (choice) {
            case 0:
              backToMain = true;
              break;
            case 1:
              doctorUI.signUpDoctor();
              break;
            case 2:
              print("\n");
              stdout.write("Enter doctorId: ");
              final doctorId = stdin.readLineSync() ?? '';
              stdout.write("Enter patientId: ");
              final patientId = stdin.readLineSync() ?? '';
              doctorUI.createPrescription(doctorId, patientId);
              break;
            case 3:
              print("\n");
              doctorUI.displayAllPrescriptions();
            case 4:
              print("\n");
              stdout.write("Enter patient ID: ");
              final patientID = stdin.readLineSync()!;
              doctorUI.displayPrescriptionByPatientID(patientID);
              break;
            case 5:
              doctorUI.updatePrescription();
              break;
            case 6:
              patientUI.viewMedical_log();
              break;

            default:
              print("Invalid choice.");
          }
        }
        break;

      case 2:
        // Patient menu loop
        bool backToMain = false;
        while (!backToMain) {
          print("\n--- Patient Menu ---");
          print("0. Back to role selection");
          print("1. Patient sign up");
          print("2. View prescription");
          print("3. Tracking medical log (mark medication)");
          print("4. View medical log ");
          stdout.write("Enter your choice: ");
          final choice = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
          switch (choice) {
            case 0:
              backToMain = true;
              break;
            case 1:
              patientUI.signUpPatient();
              break;
            case 2:
              stdout.write("Enter your ID: ");
              final patientID = stdin.readLineSync()!;
              doctorUI.displayPrescriptionByPatientID(patientID);
              break;
            case 3:
              print("\n");
              patientUI.trackPrescription();
              break;
            case 4:
              print("\n");
              patientUI.viewMedical_log();
            default:
              print("Invalid choice.");
          }
        }
        break;

      case 3:
        // Pharmacist menu loop
        bool backToMain = false;
        while (!backToMain) {
          print("\n--- Pharmacist Menu ---");
          print("0. Back to role selection");
          print("1. Add medication");
          stdout.write("Enter your choice: ");
          final choice = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
          switch (choice) {
            case 0:
              backToMain = true;
              break;
            case 1:
              pharmacistUI.addMedication();
              break;
            default:
              print("Invalid choice.");
          }
        }
        break;

      default:
        print("Invalid role selection.");
    }
  }
}
