import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mainscreen/carDataScreen.dart';
import 'package:diplomski_client/mainscreen/loginScreen.dart';
import 'package:diplomski_client/mainscreen/mainscreen.dart';
import 'package:diplomski_client/mapConfig.dart';
import 'package:diplomski_client/widgets/progressDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();

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
              Text("RYDE",
                  style: TextStyle(
                      fontFamily: "Zelda-Regular",
                      fontSize: 80,
                      letterSpacing: 15.0,
                      color: Colors.white)),
              SizedBox(height: 22),
              Text(
                "Register as Driver",
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
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Name",
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
                        decoration: InputDecoration(
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
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Phone",
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
                        decoration: InputDecoration(
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
                      RaisedButton(
                        color: Colors.teal,
                        textColor: Colors.white,
                        child: Container(
                            height: 50.0,
                            child: Center(
                                child: Text("Create Account",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand-Bold")))),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          RegExp exp = new RegExp(
                              r"^[A-Za-z0-9+_.-]+@[A-Za-z0-9+_.-]+$",
                              caseSensitive: false,
                              multiLine: false);
                          if (!exp.hasMatch(emailTEC.text)) {
                            displayToastMessage(
                                "Email address is not valid", context);
                          } else if (nameTEC.text.length < 4) {
                            displayToastMessage(
                                "Name must be at least 4 characters long",
                                context);
                          } else if (phoneTEC.text.isEmpty) {
                            displayToastMessage(
                                "Phone number field cannot be left empty",
                                context);
                          } else if (passTEC.text.length < 8) {
                            displayToastMessage(
                                "Password must be at least 8 characters long",
                                context);
                          } else
                            registerNewUser(context);
                        },
                      )
                    ],
                  )),
              FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: Text("Already have an account? Login here",
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
    final User fbUser = (await _auth
            .createUserWithEmailAndPassword(
                email: emailTEC.text, password: passTEC.text)
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
      displayToastMessage("Your account has been created", context);
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
