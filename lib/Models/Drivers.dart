import 'package:firebase_database/firebase_database.dart';

class Drivers{
  String name, phone, email, id;
  String car_color, car_model, car_plates;
  Drivers({this.name, this.phone, this.email, this.id, this.car_color, this.car_model, this.car_plates});
  Drivers.fromSnapshot(DataSnapshot data){
    id = data.key;
    phone = data.value["phone"];
    email = data.value["email"];
    name = data.value["name"];
    car_color = data.value["car_data"]["car_color"];
    car_model = data.value["car_data"]["car_model"];
    car_plates = data.value["car_data"]["car_plates"];
  }
}