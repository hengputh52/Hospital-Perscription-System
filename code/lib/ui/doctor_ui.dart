import 'dart:io';
import 'package:hospital_prescription_management/repository/patient_repository.dart';

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
  final PatientRepository patientRepo;
  
  DoctorUI(this.prescriptionRepo, this.medicationRepo, this.doctorRepo, this.patientRepo);

  

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

    void updatePrescription() {
    stdout.write('\nEnter prescription id to update: ');
    final presId = stdin.readLineSync()?.trim();
    if (presId == null || presId.isEmpty) {
      print('Invalid prescription id.');
      return;
    }

    final existing = prescriptionRepo.findById(presId);
    if (existing == null) {
      print('Prescription not found: $presId');
      return;
    }

    // Work on a mutable copy of items
    final items = existing.items.toList();
    String diagnosis = existing.diagnosis;
    String? note = existing.note;

    var done = false;
    while (!done) {
      print('\n--- Update Prescription ${existing.id} ---');
      print('1. Edit diagnosis (current: $diagnosis)');
      print('2. Edit note (current: ${note ?? "none"})');
      print('3. List items');
      print('4. Add item');
      print('5. Edit item');
      print('6. Remove item');
      print('0. Save and exit');
      stdout.write('Choose option: ');
      final choice = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

      switch (choice) {
        case 1:
          stdout.write('New diagnosis: ');
          final d = stdin.readLineSync();
          if (d != null && d.trim().isNotEmpty) diagnosis = d.trim();
          break;
        case 2:
          stdout.write('New note (empty to clear): ');
          final n = stdin.readLineSync();
          note = (n != null && n.trim().isNotEmpty) ? n.trim() : null;
          break;
        case 3:
          if (items.isEmpty) {
            print('No items.');
          } else {
            for (var i = 0; i < items.length; i++) {
              final it = items[i];
              final med = medicationRepo.findById(it.medication_id);
              final name = med?.name ?? it.medication_id;
              print('$i) $name (id:${it.medication_id}) qty:${it.quantity} freq:${it.frequency} dur:${it.duration}');
            }
          }
          break;
        case 4:
          stdout.write('Medication id: ');
          final medId = stdin.readLineSync()?.trim();
          if (medId == null || medId.isEmpty) {
            print('Invalid medication id.');
            break;
          }
          stdout.write('Quantity: ');
          final qty = int.tryParse(stdin.readLineSync() ?? '') ?? 1;
          stdout.write('Frequency: ');
          final freq = stdin.readLineSync() ?? 'daily';
          stdout.write('Duration (days): ');
          final dur = int.tryParse(stdin.readLineSync() ?? '') ?? 1;
          items.add(PrescriptionItem(medication_id: medId, quantity: qty, duration: dur, frequency: freq));
          print('Item added.');
          break;
        case 5:
          if (items.isEmpty) {
            print('No items to edit.');
            break;
          }
          stdout.write('Enter item index to edit: ');
          final idx = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
          if (idx < 0 || idx >= items.length) {
            print('Invalid index.');
            break;
          }
          final old = items[idx];
          stdout.write('New quantity (current ${old.quantity}): ');
          final nQty = int.tryParse(stdin.readLineSync() ?? '') ?? old.quantity;
          stdout.write('New frequency (current ${old.frequency}): ');
          final nFreq = stdin.readLineSync();
          stdout.write('New duration (current ${old.duration}): ');
          final nDur = int.tryParse(stdin.readLineSync() ?? '') ?? old.duration;
          // preserve id
          items[idx] = PrescriptionItem(
            id: old.id,
            medication_id: old.medication_id,
            quantity: nQty,
            frequency: (nFreq == null || nFreq.trim().isEmpty) ? old.frequency : nFreq.trim(),
            duration: nDur,
          );
          print('Item updated.');
          break;
        case 6:
          if (items.isEmpty) {
            print('No items to remove.');
            break;
          }
          stdout.write('Enter item index to remove: ');
          final rIdx = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
          if (rIdx < 0 || rIdx >= items.length) {
            print('Invalid index.');
            break;
          }
          items.removeAt(rIdx);
          print('Item removed.');
          break;
        case 0:
          done = true;
          break;
        default:
          print('Invalid option.');
      }
    }

    // Build updated prescription (preserve id and created fields)
    final updated = Prescription(
      id: existing.id,
      doctor_id: existing.doctor_id,
      patient_id: existing.patient_id,
      diagnosis: diagnosis,
      prescription_date: existing.prescription_date,
      items: items,
      note: note,
    );

    // Persist using repository update
    prescriptionRepo.update(updated);
    print('Prescription updated and saved.');
  }

  Gender? _parseGender(String? input) {
    if (input == null) return null;
    final v = input.trim().toLowerCase();
    if (v == 'm' || v == 'male') return Gender.male;
    if (v == 'f' || v == 'female') return Gender.female;
    if (v == 'o' || v == 'other') return Gender.female; // fallback to female if 'o' not supported in enum
    return null;
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

    // Require a valid gender value because Doctor.gender is non-nullable
    Gender? gender;
    while (gender == null) {
      stdout.write('Gender (m/f) [required]: ');
      final genderInput = stdin.readLineSync();
      gender = _parseGender(genderInput);
      if (gender == null) {
        print('Invalid gender. Enter "m" or "f".');
      }
    }

    stdout.write('Contact (phone/email) [optional]: ');
    final contactInput = stdin.readLineSync();
    final contact = (contactInput != null && contactInput.trim().isNotEmpty) ? contactInput.trim() : '';

    final doctor = Doctor(
      firstName: firstName,
      lastName: lastName,
      specialization: specialization,
      gender: gender,
      contactInfo: contact,
    );

    doctorRepo.add(doctor);
    print('Doctor registered with id: ${doctor.id}');
  }

    void deletePrescription() {
    stdout.write('\nEnter prescription id to delete: ');
    final id = stdin.readLineSync()?.trim();
    if (id == null || id.isEmpty) {
      print('Invalid id.');
      return;
    }
    final removed = prescriptionRepo.deleteById(id);
    if (removed) {
      print('Prescription removed successfully: $id');
    } else {
      print('Prescription not found for id: $id');
    }
  }

  void displayAllPrescriptions()
  {
    final allPrescription = prescriptionRepo.getAll();
    final allPatient = patientRepo.getAll();
    final allDoctor = doctorRepo.getAll();
    final allMedication = medicationRepo.getAll();
    if(allPrescription.isEmpty)
    {
      print("No prescription found.");
      return;
    }
    for(final all in allPrescription)
    {
      print('\n=== Prescription ${all.id} ===');
      //print('Doctor: ${all.doctor_id}');
      
      for(final doctor in allDoctor)
      {
        print("Doctor FirstName: ${doctor.firstName}");
        print("Doctor Last Name: ${doctor.lastName}");
        print("Gender: ${doctor.gender}");
        print("Specialization: ${doctor.specialization}");
        print("Contact: ${doctor.contactInfo}");
        
      }
      //print('Patient: ${all.patient_id}');
      for(final patient in allPatient)
      {
        print("Patient FirstName: ${patient.firstName}");
        print("Patient Last Name: ${patient.lastName}");
        print("Age: ${patient.age}");
        print("Gender: ${patient.gender}");
        print("Contact: ${patient.contact}");
      }
      print('Diagnosis: ${all.diagnosis}');
      print('Date: ${all.prescription_date.toIso8601String()}');
      if (all.note != null && all.note!.isNotEmpty) print('Note: ${all.note}');
      print('Items:');
      for (final med in all.items) {
        for(final m in allMedication)
        {
          if(m.id == med.medication_id)
          {
            print(' - Medication: ${m.name}, qty: ${med.quantity}, freq: ${med.frequency}, duration: ${med.duration}');

          }
        }
        //print(' - medId: ${med.medication_id}, qty: ${med.quantity}, freq: ${med.frequency}, duration: ${med.duration}');
      }
    }
  }
  void displayPrescriptionByPatientID(String patientID)
  {
    final patientPrescription = prescriptionRepo.getByPatientId(patientID);
    final patientInfo = patientRepo.findById(patientID);
    final medicationInfo = medicationRepo.getAll();
    for(final presctiption in patientPrescription)
    {
      print("\n=== Prescription ${presctiption.id} ===");
      if (patientInfo != null) {
        print("Patient First Name: ${patientInfo.firstName}");
        print("Patient Last Name: ${patientInfo.lastName}");
        print("Patient Gender: ${patientInfo.gender}");
        print("Patient Age: ${patientInfo.age}");
        print("Patient Contact: ${patientInfo.contact}");
      } else {
        print("Patient id: ${presctiption.patient_id}");
      }
      print('Diagnosis: ${presctiption.diagnosis}');
      print('Date: ${presctiption.prescription_date.toIso8601String()}');
      if (presctiption.note != null && presctiption.note!.isNotEmpty) print('Note: ${presctiption.note}');
      print('Items:');
      for (final med in presctiption.items) {
        for(final medication in medicationInfo)
        {
          if(medication.id == med.medication_id)
          {
            print(' - Medication: ${medication.name}, qty: ${med.quantity}, freq: ${med.frequency}, duration: ${med.duration}');
            print("  Description: ${medication.description}, Instruction: ${medication.instruction}");
          }
        }
      }
    }
    
  }

  void deleteDoctor() {
    stdout.write('\nEnter doctor id to delete: ');
    final id = stdin.readLineSync()?.trim();
    if (id == null || id.isEmpty) {
      print('Invalid id.');
      return;
    }

    final removed = doctorRepo.deleteById(id);
    if (removed) {
      print('Doctor removed successfully: $id');
    } else {
      print('Doctor not found for id: $id');
    }
  }

}