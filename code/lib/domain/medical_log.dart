import 'package:hospital_prescription_management/domain/patient.dart';
import 'package:uuid/uuid.dart';


class MedicalLog
{
  final String log_id;
  final String patient_id;
  final String prescription_id;
  DateTime dateTime;
  Map<String, bool> medicationStatus;


  MedicalLog({String? id,
   required this.patient_id,
   required this.prescription_id,
   required this.dateTime,
   required this.medicationStatus}) : log_id = id ?? const Uuid().v4();


   Map<String, dynamic> toJson() => {
        'log_id': log_id,
        'patient_id': patient_id,
        'prescription_id': prescription_id,
        'dateTime': dateTime.toIso8601String(),
        'medicationStatus': medicationStatus,
      };

  factory MedicalLog.fromJson(Map<String, dynamic> json) => MedicalLog(
        id: json['id'],
        prescription_id: json['prescription_id'],
        patient_id: json['patient_id'],
        dateTime: DateTime.parse(json['dateTime']),
        medicationStatus: Map<String, bool>.from(json['medicationStatus']),
      );
}