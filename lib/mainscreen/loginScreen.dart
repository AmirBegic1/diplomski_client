import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mainscreen/mainscreen.dart';
import 'package:diplomski_client/mainscreen/registrationScreen.dart';
import 'package:diplomski_client/mapConfig.dart';
import 'package:diplomski_client/widgets/progressDialog.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();
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
              Text("RYDE",
                  style: TextStyle(
                      fontFamily: "Zelda-Regular",
                      fontSize: 80,
                      letterSpacing: 15.0,
                      color: Colors.white)),
              SizedBox(height: 22.0),
              Text(
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
                      SizedBox(height: 15.0),
                      TextField(
                        controller: passTEC,
                        obscureText: true,
                        decoration: InputDecoration(
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
                      RaisedButton(
                        color: Colors.teal,
                        textColor: Colors.white,
                        child: Container(
                            height: 50.0,
                            child: Center(
                                child: Text("Login",
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
                          } else if (passTEC.text.length < 8) {
                            displayToastMessage(
                                "Password must be at least 8 characters long",
                                context);
                          } else
                            loginAndAuthUser(context);
                        },
                      )
                    ],
                  )),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Container(
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
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Brand-Bold"))),
                        ])),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {},
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.white,
                textColor: Colors.black,
                child: Container(
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
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {},
              ),
              SizedBox(height: 25),
              FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.idScreen, (route) => false);
                  },
                  child: Text("Don't have an account? Register here",
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
    final User fbUser = (await _auth
            .signInWithEmailAndPassword(
                email: emailTEC.text, password: passTEC.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;
    if (fbUser != null) {
      driverRef.child(fbUser.uid).once().then((DataSnapshot snap) {
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
