import 'package:firebase_database/firebase_database.dart';

class Users {
  String? id;
  String? email;
  String? name;
  String? phone;
  Users({this.id, this.email, this.name, this.phone});

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'phone': phone};
  }

  Users.snapShotRetrieve(DataSnapshot snap) {
    id = snap.key;
    email = (snap.child("email").value.toString());
    name = (snap.child("name").value.toString());
    phone = (snap.child("phone").value.toString());
  }
}
