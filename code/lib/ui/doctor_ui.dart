import 'dart:io';
import '../repository/prescription_repository.dart';
import '../repository/medication_repository.dart';
import '../domain/prescription.dart';
import '../domain/prescription_item.dart';
import '../domain/doctor.dart';
import '../repository/doctor_repository.dart';

class DoctorUI {
  final PrescriptionRepository prescriptionRepo;
  final MedicationRepository medicationRepo;
  final DoctorRepository doctorRepo;

  DoctorUI(this.prescriptionRepo, this.medicationRepo, this.doctorRepo);

  

  void createPrescription(String doctorId, String patientId) {
    final items = <PrescriptionItem>[];
    print("\n");
    print("--- Creating prescription for patient ---");

    stdout.write("Enter diagnosis of the patient: ");
    final diagnosis = stdin.readLineSync()!;
    stdout.write("Enter note for patient (optional): ");
    final note = stdin.readLineSync();

    while (true) {
      print("\n");
      stdout.write("Enter medication IDs (type 'done' to finish): ");
      final medId = stdin.readLineSync();
      if (medId == 'done') break;
      stdout.write("enter the Quantity of medication: ");
      final qty = int.parse(stdin.readLineSync()!);
      stdout.write("enter the Duration of medication: ");
      final duration = int.parse(stdin.readLineSync()!);
      stdout.write("enter the Frequency of medication process: ");
      final freq = stdin.readLineSync()!;
      items.add(PrescriptionItem(medication_id: medId!, quantity: qty, duration: duration, frequency: freq));
    }


    final prescription = Prescription(
      doctor_id: doctorId,
      patient_id: patientId,
      diagnosis: diagnosis,
      prescription_date: DateTime.now(),
      items: items,
      note: note
    );

    prescriptionRepo.add(prescription);
    print("Prescription created successfully!");
  }

  void displayAllPrescriptions()
  {
    final allPrescription = prescriptionRepo.getAll();
    if(allPrescription.isEmpty)
    {
      print("No prescription found.");
      return;
    }
    for(final all in allPrescription)
    {
      print('\n=== Prescription ${all.id} ===');
      print('Doctor: ${all.doctor_id}');
      print('Patient: ${all.patient_id}');
      print('Diagnosis: ${all.diagnosis}');
      print('Date: ${all.prescription_date.toIso8601String()}');
      if (all.note != null && all.note!.isNotEmpty) print('Note: ${all.note}');
      print('Items:');
      for (final med in all.items) {
        print(' - medId: ${med.medication_id}, qty: ${med.quantity}, freq: ${med.frequency}, duration: ${med.duration}');
      }
    }
  }


  void displayPrescriptionByPatientID(String patientID)
  {
    final patientPrescription = prescriptionRepo.getByPatientId(patientID);
    for(final presctiption in patientPrescription)
    {
      print("\n=== Prescription ${presctiption.id}");
      print('Doctor: ${presctiption.doctor_id}');
      print('Patient: ${presctiption.patient_id}');
      print('Diagnosis: ${presctiption.diagnosis}');
      print('Date: ${presctiption.prescription_date.toIso8601String()}');
      if (presctiption.note != null && presctiption.note!.isNotEmpty) print('Note: ${presctiption.note}');
      print('Items:');
      for (final med in presctiption.items) {
        print(' - medId: ${med.medication_id}, qty: ${med.quantity}, freq: ${med.frequency}, duration: ${med.duration}');
      }
    }
    
  }

  void signUpDoctor() {
    print("\n");
    print('--- Doctor Sign Up ---');
    stdout.write('First name: ');
    final firstName = stdin.readLineSync() ?? '';
    stdout.write('Last name: ');
    final lastName = stdin.readLineSync() ?? '';
    stdout.write('Specialization: ');
    final specialization = stdin.readLineSync() ?? '';

    final doctor = Doctor(
      firstName: firstName,
      lastName: lastName,
      specialization: specialization,
    );

    doctorRepo.add(doctor);
    print('Doctor registered with id: ${doctor.id}');
  }
}
