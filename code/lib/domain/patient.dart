import 'package:uuid/uuid.dart';

enum Gender { male, female }

class Patient {
  final String id;
  final String firstName;
  final String lastName;
  int age;
  final Gender gender;
  final String contact;

  Patient({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.contact,
  }) : id = id ?? const Uuid().v4();

  // Convert Patient object to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender.name, // convert enum to string
        'contact': contact,
      };

  // Create Patient object from JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    // Helper to parse gender string into enum
    Gender parseGender(String? g) {
      if (g == null) return Gender.male; // fallback default
      switch (g.toLowerCase()) {
        case 'male':
        case 'm':
          return Gender.male;
        case 'female':
        case 'f':
          return Gender.female;
        default:
          return Gender.male; // fallback
      }
    }

    return Patient(
      id: json['id'] as String?,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: parseGender(json['gender'] as String?),
      contact: json['contact'] as String? ?? '',
    );
  }
}
