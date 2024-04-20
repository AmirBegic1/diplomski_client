import 'package:flutter/material.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mainscreen/mainscreen.dart';
import 'package:diplomski_client/mainscreen/registrationScreen.dart';
import 'package:diplomski_client/mapConfig.dart';

class CarDataScreen extends StatefulWidget {
  static const String idScreen = "carData";

  @override
  _CarDataScreenState createState() => _CarDataScreenState();
}

class _CarDataScreenState extends State<CarDataScreen> {
  TextEditingController modelTEC = TextEditingController();

  TextEditingController platesTEC = TextEditingController();

  TextEditingController colorTEC = TextEditingController();

  String categoryVar = "Standard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: [
            SizedBox(height: 72.0),
            const Text("RYDE",
                style: TextStyle(
                    fontFamily: "Zelda-Regular",
                    fontSize: 80,
                    letterSpacing: 15.0,
                    color: Colors.white)),
            Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    Text("Enter your car details",
                        style: TextStyle(
                            fontFamily: "Brand-Bold",
                            fontSize: 24.0,
                            color: Colors.white)),
                    SizedBox(height: 30.0),
                    TextField(
                        controller: modelTEC,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Car model",
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            hintStyle:
                                TextStyle(color: Colors.teal, fontSize: 10.0)),
                        style: TextStyle(fontSize: 15.0, color: Colors.white)),
                    SizedBox(height: 10.0),
                    TextField(
                        controller: platesTEC,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Registration plates",
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            hintStyle:
                                TextStyle(color: Colors.teal, fontSize: 10.0)),
                        style: TextStyle(fontSize: 15.0, color: Colors.white)),
                    SizedBox(height: 10.0),
                    TextField(
                        controller: colorTEC,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Car colour",
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            hintStyle:
                                TextStyle(color: Colors.teal, fontSize: 10.0)),
                        style: TextStyle(fontSize: 15.0, color: Colors.white)),
                    SizedBox(height: 30.0),
                    Text("Your car type",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(height: 10.0),
                    DropdownButton(
                        dropdownColor: Colors.teal,
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Brand-Bold"),
                        value: categoryVar,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        elevation: 12,
                        onChanged: (String? newVal) {
                          setState(() {
                            if (newVal != null) categoryVar = newVal;
                          });
                        },
                        items: <String>["Standard", "Premium", "Bike"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        underline: Container()),
                    SizedBox(height: 25.0),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(
                                        color: Colors.black87, width: 1.9)),
                                backgroundColor: Colors.teal),
                            onPressed: () {
                              RegExp exp = RegExp(
                                  r"^[A-Za-z][0-9][0-9]-[A-Za-z]-[0-9][0-9][0-9]$",
                                  caseSensitive: false,
                                  multiLine: false);
                              if (modelTEC.text.isEmpty) {
                                displayToastMessage(
                                    "The car model field is mandatory",
                                    context);
                              } else if (!exp.hasMatch(platesTEC.text))
                                // ignore: curly_braces_in_flow_control_structures
                                displayToastMessage(
                                    "The registration plates are not valid",
                                    context);
                              else if (colorTEC.text.isEmpty)
                                // ignore: curly_braces_in_flow_control_structures
                                displayToastMessage(
                                    "The car color field is mandatory",
                                    context);
                              else
                                // ignore: curly_braces_in_flow_control_structures
                                saveCarDataToDB(context);
                            },
                            child: const Padding(
                                padding: EdgeInsets.all(17.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Next",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      Icon(Icons.arrow_forward,
                                          color: Colors.white, size: 26.0)
                                    ]))))
                  ],
                ))
          ],
        ))));
  }

  void saveCarDataToDB(context) {
    String uid = currentUser!.uid;
    Map carMap = {
      "car_color": colorTEC.text,
      "car_plates": platesTEC.text,
      "car_model": modelTEC.text,
      "type": categoryVar.toLowerCase()
    };
    driverRef.child(uid).child("car_data").set(carMap);
    displayToastMessage("Registration successful", context);
    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.idScreen, (route) => false);
  }
}
