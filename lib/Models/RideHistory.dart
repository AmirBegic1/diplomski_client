import 'package:firebase_database/firebase_database.dart';

class RideHistory{
  String payment_method, created_at, status, fares, dropOff, pickUp;
  RideHistory({this.payment_method, this.created_at, this.status, this.fares, this.dropOff, this.pickUp});
  RideHistory.fromSnapshot(DataSnapshot data){
    payment_method = data.value["payment_method"];
    created_at = data.value["created_at"];
    status = data.value["status"];
    fares = data.value["fares"];
    dropOff = data.value["dropoff_address"];
    pickUp = data.value["pickup_address"];
  }
}