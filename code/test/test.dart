import 'dart:io';
import 'package:test/test.dart';

import 'package:hospital_prescription_management/domain/doctor.dart';
import 'package:hospital_prescription_management/domain/patient.dart' as p;
import 'package:hospital_prescription_management/domain/prescription.dart';
import 'package:hospital_prescription_management/domain/prescription_item.dart';
import 'package:hospital_prescription_management/domain/medication.dart';

import 'package:hospital_prescription_management/repository/doctor_repository.dart';
import 'package:hospital_prescription_management/repository/patient_repository.dart';
import 'package:hospital_prescription_management/repository/medication_repository.dart';
import 'package:hospital_prescription_management/repository/prescription_repository.dart';

void main() {
  // File paths used by the repositories (project-relative)
  final base = 'code/lib/data';
  final doctorsPath = '$base/doctors.json';
  final patientsPath = '$base/patients.json';
  final medsPath = '$base/medications.json';
  final prescriptionsPath = '$base/prescriptions.json';
  final medicalLogsPath = '$base/medical_logs.json';

  // Backup originals so tests can safely restore
  final Map<String, String?> originalFiles = {};

  setUpAll(() {
    for (final p in [doctorsPath, patientsPath, medsPath, prescriptionsPath, medicalLogsPath]) {
      final f = File(p);
      originalFiles[p] = f.existsSync() ? f.readAsStringSync() : null;
    }
  });

  tearDownAll(() {
    // restore originals
    for (final entry in originalFiles.entries) {
      final path = entry.key;
      final content = entry.value;
      final f = File(path);
      if (content == null) {
        // remove file if it didn't exist originally
        if (f.existsSync()) f.deleteSync();
      } else {
        // restore original content
        if (!f.parent.existsSync()) f.parent.createSync(recursive: true);
        f.writeAsStringSync(content, flush: true);
      }
    }
  });

  group('Repository integration tests', () {
    final docRepo = DoctorRepository();
    final patRepo = PatientRepository();
    final medRepo = MedicationRepository();
    final presRepo = PrescriptionRepository();

    test('Medication repo add/find/delete', () {
      // initial count
      final before = medRepo.getAll().length;

      final med = Medication.fromJson({
        'id': 't-med-1',
        'name': 'TestMed',
        'description': 'Test medication',
        'dosageForm': 'tablet',
        'strength': '50mg',
        'instruction': 'Take once'
      });

      medRepo.addMedication(med);
      final found = medRepo.findById(med.id);
      expect(found, isNotNull);
      expect(found!.name, equals('TestMed'));

      // cleanup: delete and assert removed
      final deleted = medRepo.deleteById(med.id);
      expect(deleted, isTrue);
      expect(medRepo.getAll().length, equals(before));
    });

    test('Doctor add/update/delete', () {
      final before = docRepo.getAll().length;

      final doctor = Doctor(
        firstName: 'Test',
        lastName: 'Doctor',
        specialization: 'TestSpec',
        gender: Gender.male,
        contactInfo: '',
      );
      docRepo.add(doctor);

      final got = docRepo.findById(doctor.id);
      expect(got, isNotNull);
      expect(got!.firstName, equals('Test'));

      // update
      final updated = Doctor(
        id: doctor.id,
        firstName: doctor.firstName,
        lastName: doctor.lastName,
        specialization: 'UpdatedSpec', gender: Gender.male, contactInfo: '0089893983',
      );
      docRepo.add(updated);
      final got2 = docRepo.findById(doctor.id);
      expect(got2, isNotNull);
      expect(got2!.specialization, equals('UpdatedSpec'));

      // delete
      final deleted = docRepo.deleteById(doctor.id);
      expect(deleted, isTrue);
      expect(docRepo.getAll().length, equals(before));
    });

    test('Patient add/update/delete', () {
      final before = patRepo.getAll().length;

      final patient = p.Patient(
        firstName: 'TestP',
        lastName: 'User',
        age: 30,
        contact: '0123456789',
        gender: p.Gender.male,
      );
      // add/update exists in repository
      patRepo.add(patient);

      final got = patRepo.findById(patient.id);
      expect(got, isNotNull);
      expect(got!.firstName, equals('TestP'));

      // update field and call update()
      final updated = p.Patient(
        id: patient.id,
        firstName: patient.firstName,
        lastName: patient.lastName,
        age: 31,
        contact: patient.contact,
        gender: patient.gender,
      );
      patRepo.add(updated);
      final got2 = patRepo.findById(patient.id);
      expect(got2, isNotNull);
      expect(got2!.age, equals(31));

      final deleted = patRepo.deleteById(patient.id);
      expect(deleted, isTrue);
      expect(patRepo.getAll().length, equals(before));
    });

    test('Prescription create/update/delete flow', () {
      // create one medication to reference
      final med = Medication.fromJson({
        'id': 't-med-pres-1',
        'name': 'PresMed',
        'description': 'For prescription test',
        'dosageForm': 'tablet',
        'strength': '10mg',
        'instruction': 'Test instruction'
      });
      medRepo.addMedication(med);

      // create doctor and patient
      final doctor = Doctor(firstName: 'Dpres', lastName: 'One', specialization: 'Spec', gender: Gender.male, contactInfo: '09987774');
      docRepo.add(doctor);
      final patient = p.Patient(firstName: 'Ppres', lastName: 'One', age: 40, contact: '000', gender: p.Gender.male);
      patRepo.add(patient);

      // build prescription
      final item = PrescriptionItem(
        medication_id: med.id,
        quantity: 2,
        frequency: 'once a day',
        duration: 5,
      );
      final pres = Prescription(
        doctor_id: doctor.id,
        patient_id: patient.id,
        diagnosis: 'TestDiag',
        prescription_date: DateTime.now(),
        items: [item],
        note: 'unit test',
      );

      presRepo.add(pres);
      final fetched = presRepo.findById(pres.id);
      expect(fetched, isNotNull);
      expect(fetched!.items.length, equals(1));
      expect(fetched.patient_id, equals(patient.id));

      // update prescription (change diagnosis)
      final upd = Prescription(
        id: pres.id,
        doctor_id: pres.doctor_id,
        patient_id: pres.patient_id,
        diagnosis: 'UpdatedDiag',
        prescription_date: pres.prescription_date,
        items: pres.items,
        note: pres.note,
      );
      presRepo.update(upd);
      final fetched2 = presRepo.findById(pres.id);
      expect(fetched2, isNotNull);
      expect(fetched2!.diagnosis, equals('UpdatedDiag'));

      // delete prescription
      final deleted = presRepo.deleteById(pres.id);
      expect(deleted, isTrue);
      expect(presRepo.findById(pres.id), isNull);

      // cleanup doctor, patient, med
      expect(docRepo.deleteById(doctor.id), isTrue);
      expect(patRepo.deleteById(patient.id), isTrue);
      expect(medRepo.deleteById(med.id), isTrue);
    });
  });
}