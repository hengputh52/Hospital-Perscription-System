import 'package:hospital_prescription_management/domain/patient.dart';

class Medication
{
  final String id;
  final String name;
  final String dosageForm;
  final String instruction;

  Medication({String? id,
   required this.name,
   required this.dosageForm,
   required this.instruction}) : id = id ?? uuid.v4();

}