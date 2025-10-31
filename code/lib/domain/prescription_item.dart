import 'package:hospital_prescription_management/domain/patient.dart';

class PrescriptionItem
{
  final String id;
  final String medication_id;
  final int quantity;
  final String frequency;
  final int duration;

  PrescriptionItem({
    String? id,
    required this.medication_id,
    required this.quantity,
    required this.duration, 
    required this.frequency}) : id = id ?? uuid.v4();


}