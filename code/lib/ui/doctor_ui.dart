import 'dart:io';
import '../repository/prescription_repository.dart';
import '../repository/medication_repository.dart';
import '../domain/prescription.dart';
import '../domain/prescription_item.dart';

class DoctorUI {
  final PrescriptionRepository prescriptionRepo;
  final MedicationRepository medicationRepo;

  DoctorUI(this.prescriptionRepo, this.medicationRepo);

  void createPrescription(String doctorId, String patientId) {
    final items = <PrescriptionItem>[];

    print("Enter medication IDs (type 'done' to finish):");
    while (true) {
      final medId = stdin.readLineSync();
      if (medId == 'done') break;
      print("enter the Quantity of medication:");
      final qty = int.parse(stdin.readLineSync()!);
      print("enter the Duration of medication:");
      final duration = int.parse(stdin.readLineSync()!);
      print("enter the Frequency of medication process");
      final freq = stdin.readLineSync()!;
      items.add(PrescriptionItem(medication_id: medId!, quantity: qty, duration: duration, frequency: freq));
    }

    final prescription = Prescription(
      doctor_id: doctorId,
      patient_id: patientId,
      prescription_date: DateTime.now(),
      items: items,
    );

    prescriptionRepo.add(prescription);
    print("Prescription created successfully!");
  }
}
