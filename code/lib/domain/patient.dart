import 'package:uuid/uuid.dart';

var uuid = Uuid();
class Patient
{
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String contact;

  Patient({String? id,
   required this.firstName,
   required this.lastName,
   required this.age, 
   required this.contact}) : id = id ?? uuid.v4();

  

  @override
  String toString() {
    return 'patient_id : $id \nFirst Name: $firstName \nLast Name: $lastName \nAge: $age \nContact: $contact';
  }


}