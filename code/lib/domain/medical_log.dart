import 'package:hospital_prescription_management/domain/patient.dart';

class MedicalLog
{
  final String log_id;
  final String patient_id;
  final String prescriptionItem_id;
  final String medication_id;
  DateTime dateTime;
  bool taken;


  MedicalLog({String? id,
   required this.patient_id,
   required this.prescriptionItem_id,
   required this.medication_id,
   required DateTime dateTime,
   required this.taken}) : log_id = id ?? uuid.v4(), dateTime = dateTime;
}