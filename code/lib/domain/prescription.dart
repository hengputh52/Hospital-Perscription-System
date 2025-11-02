import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:hospital_prescription_management/domain/prescription_item.dart';
import 'package:hospital_prescription_management/domain/medication.dart';

class Prescription {
  final String id;
  final String doctor_id;
  final String patient_id;
  DateTime prescription_date;
  List<PrescriptionItem> items;
  final String? note;

  Prescription({
    String? id,
    required this.doctor_id,
    required this.patient_id,
    required this.prescription_date,
    required this.items,
     this.note,
  })  : id = id ?? const Uuid().v4();


  void addPrescriptionItem(PrescriptionItem item) {
    items.add(item);
  }


  factory Prescription.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    return Prescription(
      id: json['id'] as String?,
      doctor_id: json['doctor_id'] as String,
      patient_id: json['patient_id'] as String,
      prescription_date: DateTime.parse(json['prescription_date'] as String),
      items: itemsJson
          .map((e) => PrescriptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctor_id': doctor_id,
        'patient_id': patient_id,
        'prescription_date': prescription_date.toIso8601String(),
        'items': items.map((i) => i.toJson()).toList(),
        'note': note,
      };

  @override
  String toString() {
    return 'Prescription{id: $id, doctor_id: $doctor_id, patient_id: $patient_id, date: ${prescription_date.toIso8601String()}, items: ${items.length}}';
  }
}