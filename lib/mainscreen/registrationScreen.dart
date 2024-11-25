import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mainscreen/carDataScreen.dart';
import 'package:diplomski_client/mainscreen/loginScreen.dart';
// import 'package:diplomski_client/mainscreen/mainscreen.dart';
import 'package:diplomski_client/mapConfig.dart';
import 'package:diplomski_client/widgets/progressDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();

  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 100),
              const Text("RYDE",
                  style: TextStyle(
                      fontFamily: "Zelda-Regular",
                      fontSize: 80,
                      letterSpacing: 15.0,
                      color: Colors.white)),
              SizedBox(height: 22),
              const Text(
                "Registruj se kao vozač",
                style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: "Brand-Bold",
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    children: [
                      SizedBox(height: 1.0),
                      TextField(
                        controller: nameTEC,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Ime i prezime",
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            hintStyle:
                                TextStyle(color: Colors.teal, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      SizedBox(height: 1.0),
                      TextField(
                        controller: emailTEC,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Email",
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            hintStyle:
                                TextStyle(color: Colors.teal, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      SizedBox(height: 1.0),
                      TextField(
                        controller: phoneTEC,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Broj telefona",
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            hintStyle:
                                TextStyle(color: Colors.teal, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      SizedBox(height: 1.0),
                      TextField(
                        controller: passTEC,
                        obscureText: true,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Password",
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            hintStyle:
                                TextStyle(color: Colors.teal, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      SizedBox(height: 40.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(color: Colors.white),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                        child: const SizedBox(
                            height: 50.0,
                            child: Center(
                                child: Text("Kreiraj profil!",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand-Bold")))),
                        onPressed: () {
                          RegExp exp = RegExp(
                              r"^[A-Za-z0-9+_.-]+@[A-Za-z0-9+_.-]+$",
                              caseSensitive: false,
                              multiLine: false);
                          if (!exp.hasMatch(emailTEC.text)) {
                            displayToastMessage("Email nije validan", context);
                          } else if (nameTEC.text.length < 4) {
                            displayToastMessage(
                                "Name must be at least 4 characters long",
                                context);
                          } else if (phoneTEC.text.isEmpty) {
                            displayToastMessage(
                                "Morate unijet broj telefona", context);
                          } else if (passTEC.text.length < 8) {
                            displayToastMessage(
                                "Password mora imati najmanje 8 karaktera",
                                context);
                          } else
                            registerNewUser(context);
                        },
                      )
                    ],
                  )),
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: const Text("Već imaš profil? Logiraj se!",
                      style: TextStyle(color: Colors.teal)))
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Registering user. Please wait");
        });
    final User? fbUser = (await _auth
            .createUserWithEmailAndPassword(
                email: emailTEC.text, password: passTEC.text)
            // ignore: body_might_complete_normally_catch_error
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;
    if (fbUser != null) {
      Map userDM = {
        "name": nameTEC.text.trim(),
        "email": emailTEC.text.trim(),
        "phone": phoneTEC.text
      };
      driverRef.child(fbUser.uid).set(userDM);
      currentUser = fbUser;
      displayToastMessage("VAŠ PROFIL JE USPJEŠNO KREIRAN!", context);
      Navigator.pushNamed(context, CarDataScreen.idScreen);
    } else {
      Navigator.pop(context);
      displayToastMessage("New user has not been created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
