import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mainscreen/mainscreen.dart';
import 'package:diplomski_client/mainscreen/registrationScreen.dart';
import 'package:diplomski_client/mapConfig.dart';
import 'package:diplomski_client/widgets/progressDialog.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 100.0),
              const Text("RYDE",
                  style: TextStyle(
                      fontFamily: "Zelda-Regular",
                      fontSize: 80,
                      letterSpacing: 15.0,
                      color: Colors.white)),
              SizedBox(height: 22.0),
              const Text(
                "Login as Driver",
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
                        style: const TextStyle(
                            fontSize: 14.0, color: Colors.white),
                      ),
                      SizedBox(height: 15.0),
                      TextField(
                        controller: passTEC,
                        obscureText: true,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.teal, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      SizedBox(height: 40.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                        child: const SizedBox(
                            height: 50.0,
                            child: Center(
                                child: Text("Login",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand-Bold")))),
                        onPressed: () {
                          RegExp exp = RegExp(
                              r"^[A-Za-z0-9+_.-]+@[A-Za-z0-9+_.-]+$",
                              caseSensitive: false,
                              multiLine: false);
                          if (!exp.hasMatch(emailTEC.text)) {
                            displayToastMessage(
                                "Email address is not valid", context);
                          } else if (passTEC.text.length < 8) {
                            displayToastMessage(
                                "Password must be at least 8 characters long",
                                context);
                          } else
                            // ignore: curly_braces_in_flow_control_structures
                            loginAndAuthUser(context);
                        },
                      )
                    ],
                  )),
              SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                child: SizedBox(
                    height: 50.0,
                    width: 250,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.facebook),
                          SizedBox(width: 20),
                          Center(
                              child: Text("Login with Facebook",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: "Brand-Bold"))),
                        ])),
                onPressed: () {},
              ),
              SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(color: Colors.black),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                child: const SizedBox(
                    height: 50.0,
                    width: 250,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.google),
                          SizedBox(width: 20),
                          Center(
                              child: Text("Login with Google",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Brand-Bold"))),
                        ])),
                onPressed: () {},
              ),
              SizedBox(height: 25),
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.idScreen, (route) => false);
                  },
                  child: const Text("Don't have an account? Register here",
                      style: TextStyle(color: Colors.teal))),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void loginAndAuthUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Authenticating user. Please wait");
        });
    final User? fbUser = (await _auth
            .signInWithEmailAndPassword(
                email: emailTEC.text, password: passTEC.text)
            // ignore: body_might_complete_normally_catch_error
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;
    if (fbUser != null) {
      driverRef.child(fbUser.uid).get().then((DataSnapshot snap) {
        if (snap.value != null) {
          currentUser = fbUser;
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Login successful", context);
        } else {
          Navigator.pop(context);
          _auth.signOut();
          displayToastMessage("Invalid username or password", context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("Internal error: Could not sign in", context);
    }
  }
}
