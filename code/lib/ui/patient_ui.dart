import 'package:hospital_prescription_management/domain/patient.dart';
import 'package:hospital_prescription_management/repository/medication_repository.dart';
import 'package:hospital_prescription_management/repository/patient_repository.dart';
import 'package:hospital_prescription_management/repository/prescription_repository.dart';
import '../repository/medical_log_repository.dart';
import 'package:hospital_prescription_management/domain/medication.dart';
import '../domain/medical_log.dart';
import 'dart:io';

class PatientUI {
  final MedicalLogRepository logRepo;
  final PatientRepository patietRepo;
  final PrescriptionRepository prescriptionRepo;
  final MedicationRepository medicationRepo;

  PatientUI(this.logRepo, this.patietRepo, this.prescriptionRepo, this.medicationRepo);

  void signUpPatient()
  {
    print("\n");
    print("--- Patient sign up ---");
    stdout.write('First name: ');
    final firstName = stdin.readLineSync() ?? '';
    stdout.write('Last name: ');
    final lastName = stdin.readLineSync() ?? '';
    stdout.write('Age: ');
    final age = int.parse(stdin.readLineSync()!);
    stdout.write('contact: ');
    final contact = stdin.readLineSync() ?? '';

    final patient = Patient(
      firstName: firstName,
      lastName: lastName,
      age: age,
      contact: contact);

    patietRepo.add(patient);
    print("Patient registed successfully with id : ${patient.id}");

  }

  void trackPrescription()
  {
    stdout.write('\nEnter prescription id: ');
    final presId = stdin.readLineSync();
    if (presId == null || presId.trim().isEmpty) {
      print('Invalid prescription id.');
      return;
    }

    final prescription = prescriptionRepo.findById(presId);
    if (prescription == null) {
      print('Prescription not found for id: $presId');
      return;
    }

    print('\n--- Prescription ${prescription.id} ---');
    print('Doctor: ${prescription.doctor_id}');
    print('Patient: ${prescription.patient_id}');
    print('Diagnosis: ${prescription.diagnosis}');
    print('Date: ${prescription.prescription_date.toIso8601String()}');
    if (prescription.note != null && prescription.note!.isNotEmpty) print('Note: ${prescription.note}');
    print('\nMedications:');

    final Map<String, bool> statuses = {};

    for (final item in prescription.items) {
      final Medication? med = medicationRepo.findById(item.medication_id);
      final medName = med?.name ?? item.medication_id;
      print(' - ${medName} (id: ${item.medication_id}), qty: ${item.quantity}, freq: ${item.frequency}, duration: ${item.duration}');
      stdout.write('Have you taken this medication? (y/n): ');
      final answer = (stdin.readLineSync() ?? '').trim().toLowerCase();
      final taken = answer == 'y' || answer == 'yes';
      statuses[item.medication_id] = taken;
    }

    // patient id input (double-check)
    stdout.write('\nEnter your patient id to record log: ');
    final patientId = stdin.readLineSync();
    if (patientId == null || patientId.trim().isEmpty) {
      print('Invalid patient id. Aborting log.');
      return;
    }

    final log = MedicalLog(
      prescription_id: prescription.id,
      patient_id: patientId,
      dateTime: DateTime.now(),
      medicationStatus: statuses,
    );

    logRepo.add(log);
    print('Medical log saved. Summary:');
    statuses.forEach((medId, taken) {
      final med = medicationRepo.findById(medId);
      final name = med?.name ?? medId;
      print(' - $name: ${taken ? "taken" : "missed"}');
    });
  }

  void viewMedical_log()
  {
    stdout.write("Enter your pateint ID: ");
    final patientID = stdin.readLineSync()?.trim();
    if (patientID == null || patientID.isEmpty) {
      print('Invalid patient id.');
      return;
    }

    final medical_logs = logRepo.getByPatient(patientID);
    if (medical_logs.isEmpty) {
      print('No medical logs found for patient id: $patientID');
      return;
    }

    for (final med_log in medical_logs) {
      print("\n=== Medical Log ===");
      print("Log id: ${med_log.log_id}");
      print("Date: ${med_log.dateTime.toIso8601String()}");
      print("Prescription ID: ${med_log.prescription_id}");
      // try to show prescription summary if available
      final prescription = prescriptionRepo.findById(med_log.prescription_id);
      if (prescription != null) {
        print("Diagnosis: ${prescription.diagnosis}");
        print("Doctor: ${prescription.doctor_id}");
      }

      // AI-generated
      print("\nMedication statuses:");
      final statusMap = med_log.medicationStatus;
      if (statusMap.isEmpty) {
        print("  (no medication entries)");
      } else {
        for (final entry in statusMap.entries) {
        final medId = entry.key;
        final rawVal = entry.value;
        final taken = rawVal.toString().toLowerCase() == 'true';
        final med = medicationRepo.findById(medId);
        final medName = med?.name ?? medId;
        // try to get prescribed details from prescription items
        String details = '';
          if (prescription != null) {
            for (final it in prescription.items) {
              if (it.medication_id == medId) {
                details = ' qty:${it.quantity}, freq:${it.frequency}, duration:${it.duration}';
                break;
              }
            }
          }
          print(' - $medName (id: $medId)$details : ${taken ? "taken" : "missed"}');
        }
      }
    }
  }

  void deletePatient() {
    stdout.write('\nEnter patient id to delete: ');
    final id = stdin.readLineSync()?.trim();
    if (id == null || id.isEmpty) {
      print('Invalid id.');
      return;
    }
    final removed = patietRepo.deleteById(id);
    if (removed) {
      print('Patient removed successfully.');
    } else {
      print('Patient not found for id: $id');
    }
  }

}



