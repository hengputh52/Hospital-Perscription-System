import 'package:uuid/uuid.dart';
enum Gender {male, female}
class Doctor {
  final String id;
  final String firstName;
  final String lastName;
  final Gender gender;
  final String specialization;
  final String contactInfo;

  Doctor({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.specialization,
    required this.contactInfo,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'specialization': specialization,
        'gender' : gender.name,
        'contactInfo' : contactInfo
      };

factory Doctor.fromJson(Map<String, dynamic> json) {
  // parse gender string into enum
  Gender parseGender(String? g) {
    if (g == null) return Gender.male; // default fallback
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

  return Doctor(
    id: json['id'] as String?,
    firstName: (json['firstName'] ?? json['first_name'] ?? '') as String,
    lastName: (json['lastName'] ?? json['last_name'] ?? '') as String,
    gender: parseGender(json['gender'] as String?),
    specialization: (json['specialization'] ?? '') as String,
    contactInfo: (json['contactInfo'] ?? '') as String,
  );
}

}
