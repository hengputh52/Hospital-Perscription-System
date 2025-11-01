import 'package:hospital_prescription_management/domain/medication.dart';
import 'package:hospital_prescription_management/domain/patient.dart';
import 'package:hospital_prescription_management/domain/prescription_item.dart';

class Prescription
{
  final String id;
  final String doctor_id;
  final String patient_id;
  DateTime prescription_date;
  List<PrescriptionItem> items;
  final String? note;


  Prescription({String? id,
    required this.doctor_id,
    required this.patient_id,
    required DateTime prescription_date,
    required this.items,
    this.note}) : id = id ?? uuid.v4(), prescription_date = prescription_date;


  void addPrescriptionItem(PrescriptionItem item)
  {
    items.add(item);
  }

  

  


  
}