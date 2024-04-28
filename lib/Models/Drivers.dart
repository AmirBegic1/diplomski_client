// // ignore: file_names
// import 'package:firebase_database/firebase_database.dart';

// class Drivers {
//   String? name, phone, email, id;
//   String? car_color, car_model, car_plates;
//   Drivers(
//       {this.name,
//       this.phone,
//       this.email,
//       this.id,
//       this.car_color,
//       this.car_model,
//       this.car_plates});
//   Drivers.fromSnapshot(DataSnapshot data) {
//     id = data.key;
//     phone = (data.child("phone").value.toString());
//     email = (data.child("email").value.toString());
//     name = (data.child("name").value.toString());
//     car_color = (data.child("car_data").child("car_color").value.toString());
//     // car_color = data.value["car_data"]["car_color"];
//     car_model = (data.child("car_data").child("car_model").value.toString());
//     car_plates = (data.child("car_data").child("car_plates").value.toString());
//   }
// }
import 'package:firebase_database/firebase_database.dart';

class Drivers {
  String? id; // Assuming ID is always present (remove final if not)
  String? name;
  String? phone;
  String? email;
  String? car_color;
  String? car_model;
  String? car_plates;

  Drivers({
    required this.id,
    this.name,
    this.phone,
    this.email,
    this.car_color,
    this.car_model,
    this.car_plates,
  });

  Drivers.fromSnapshot(DataSnapshot data) {
    id = data.key;
    phone = (data.child("phone").value.toString());
    email = (data.child("email").value.toString());
    name = (data.child("name").value.toString());
    car_color = (data.child("car_data").child("car_color").value.toString());
    car_model = (data.child("car_data").child("car_model").value.toString());
    car_plates = (data.child("car_data").child("car_plates").value.toString());
  }

  // factory Drivers.fromSnapshot(DataSnapshot snapshot) {
  //   final id = snapshot.key ?? ''; // Handle potential missing key

  //   // Check if data is a map-like structure (e.g., dictionary)
  //   if (snapshot.value is Map<String, dynamic>) {
  //     final data = snapshot.value as Map<String, dynamic>;
  //     return Drivers(
  //       id: id,
  //       name: data['name'] as String?,
  //       phone: data['phone'] as String?,
  //       email: data['email'] as String?,
  //       car_color: data['car_data']?['car_color'] as String?,
  //       car_model: data['car_data']?['car_model'] as String?,
  //       car_plates: data['car_data']?['car_plates'] as String?,
  //     );
  //   } else {
  //     // Handle the case where data is not a map
  //     print('Error: Data from Firebase is not in the expected format.');
  //     throw Exception(
  //         'Error: Data from Firebase is not in the expected format.'); // Or throw an exception if preferred
  //   }
}
