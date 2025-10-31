import 'package:hospital_prescription_management/domain/patient.dart';
import 'package:hospital_prescription_management/domain/prescription.dart';
import 'package:hospital_prescription_management/domain/prescription_item.dart';

class Doctor
{
  final String id;
  final String firstName;
  final String lastName;
  final String specialization;


  Doctor({String? id,
   required this.firstName,
   required this.lastName,
   required this.specialization}) : id = id ?? uuid.v4();


   void createPrecription(Patient patient, List<PrescriptionItem> item)
   {
      Prescription prescription = Prescription(doctor_id: id, patient_id: patient.id, prescription_date: DateTime.now(), items: item);

      print('yes');
   }

}