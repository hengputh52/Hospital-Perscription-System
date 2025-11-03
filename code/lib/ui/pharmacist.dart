import 'package:hospital_prescription_management/domain/medication.dart';
import 'package:hospital_prescription_management/repository/medication_repository.dart';
import 'dart:io';

class PharmacistUI
{
  final MedicationRepository medicationRepo;

  PharmacistUI(this.medicationRepo);

  void addMedication()
  {
    print("--- adding medication to databae ---");
    
    while(true)
    {
      stdout.write("Enter enter to continue and enter (done) when finish adding medication: ");
      final choice = stdin.readLineSync();
      if(choice!.toLowerCase() == 'done') break;
      stdout.write('Enter name of medication: ');
      final name = stdin.readLineSync() ?? '';
      stdout.write('Enter description about this medication: ');
      final description = stdin.readLineSync() ?? '';
      stdout.write('Enter dosage form of the medication: ');
      final dosageForm = stdin.readLineSync() ?? '';
      stdout.write('Enter insturctuion of the mediacation: ');
      final instruction = stdin.readLineSync() ?? '';

      final medication = Medication(
        name: name,
        description: description,
        dosageForm: dosageForm,
        instruction: instruction);

      medicationRepo.add(medication);
      print("adding medication successfully");

    }
  }
}