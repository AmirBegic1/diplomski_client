import 'package:firebase_database/firebase_database.dart';

class RideHistory {
  String? payment_method, created_at, status, fares, dropOff, pickUp;
  RideHistory(
      {this.payment_method,
      this.created_at,
      this.status,
      this.fares,
      this.dropOff,
      this.pickUp});
  RideHistory.fromSnapshot(DataSnapshot data) {
    payment_method = (data.child("payment_method").value.toString());
    created_at = (data.child("created_at").value.toString());
    status = (data.child("status").value.toString());
    fares = (data.child("fares").value.toString());
    dropOff = (data.child("dropoff_address").value.toString());
    pickUp = (data.child("pickup_address").value.toString());
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'payment_method': payment_method,
  //     'created_at': created_at,
  //     'status': status,
  //     'fares': fares,
  //     'dropOff': dropOff,
  //     'pickUp': pickUp
  //   };
  // }

  // RideHistory.fromDocumentSnapshot(DataSnapshot<Map<String,dynamic>> doc) : id = doc.id,
  //       payment_method = doc.data()!["payment_method"],
  //       created_at = doc.data()!["created_at"],
  //       salary = doc.data()!["salary"],
  //       address = Address.fromMap(doc.data()!["address"]),
  //       employeeTraits = doc.data()?["employeeTraits"] == null
  //           ? null
  //           : doc.data()?["employeeTraits"].cast<String>();
}
