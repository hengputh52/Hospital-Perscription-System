import 'package:uuid/uuid.dart';

class Doctor {
  final String id;
  final String firstName;
  final String lastName;
  final String specialization;

  Doctor({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.specialization,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'specialization': specialization,
      };

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json['id'] as String?,
        firstName: (json['firstName'] ?? json['first_name'] ?? '') as String,
        lastName: (json['lastName'] ?? json['last_name'] ?? '') as String,
        specialization: (json['specialization'] ?? '') as String,
      );
}
