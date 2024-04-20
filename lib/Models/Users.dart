import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Users{
  String id;
  String email;
  String name;
  String phone;
  Users({this.id, this.email, this.name, this.phone});
  Users.snapShotRetrieve(DataSnapshot snap){
    id = snap.key;
    email = snap.value["email"];
    name = snap.value["name"];
    phone = snap.value["phone"];
  }
}