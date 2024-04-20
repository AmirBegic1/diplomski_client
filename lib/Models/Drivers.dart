// ignore: file_names
import 'package:firebase_database/firebase_database.dart';

class Drivers {
  String? name, phone, email, id;
  // ignore: non_constant_identifier_names
  String? car_color, car_model, car_plates;
  Drivers(
      {this.name,
      this.phone,
      this.email,
      this.id,
      this.car_color,
      this.car_model,
      this.car_plates});
  Drivers.fromSnapshot(DataSnapshot data) {
    id = data.key;
    phone = (data.child("phone").value.toString());
    email = (data.child("email").value.toString());
    name = (data.child("name").value.toString());
    car_color = (data.child("car_data").child("car_color").value.toString());
    // car_color = data.value["car_data"]["car_color"];
    car_model = (data.child("car_data").child("car_model").value.toString());
    car_plates = (data.child("car_data").child("car_plates").value.toString());
  }
}
