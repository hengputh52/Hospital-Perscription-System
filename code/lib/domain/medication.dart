import 'package:uuid/uuid.dart';

class Medication {
  final String id;
  final String name;
  final String description;
  final String dosageForm;
  final String instruction;

  Medication({
    String? id,
    required this.name,
    required this.description,
    required this.dosageForm,
    required this.instruction,
  }) : id = id ?? const Uuid().v4();

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dosageForm: json['dosageForm'] as String? ?? '',
      instruction: json['instruction'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'dosageForm': dosageForm,
        'instruction': instruction,
      };
}
