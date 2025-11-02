import 'package:uuid/uuid.dart';


class PrescriptionItem {
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
    required this.frequency,
  }) : id = id ?? const Uuid().v4();

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    return PrescriptionItem(
      id: json['id'] as String?,
      medication_id: json['medication_id'] as String,
      quantity: json['quantity'] as int,
      frequency: json['frequency'] as String,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'medication_id': medication_id,
        'quantity': quantity,
        'frequency': frequency,
        'duration': duration,
      };
}