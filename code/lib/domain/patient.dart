import 'package:uuid/uuid.dart';

class Patient {
  final String id;
  final String fistName;
  final String lastName;
  int age;
  final String contact;


  Patient({
    String? id,
    required this.fistName,
    required this.lastName,
    required this.age,
    required this.contact
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': fistName,
        'lastName' : lastName,
        'age': age,
        'contact' : contact
      };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json['id'],
        fistName: json['firstName'],
        lastName: json['lastName'],
        age: json['age'],
        contact: json['contact']
      );
}
