import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diplomski_client/DataHandler/appData.dart';
import 'package:diplomski_client/mainscreen/carDataScreen.dart';
import 'package:diplomski_client/mainscreen/loginScreen.dart';
import 'package:diplomski_client/mainscreen/mainscreen.dart';
import 'package:diplomski_client/mainscreen/registrationScreen.dart';
import 'package:provider/provider.dart';
import 'package:diplomski_client/mapConfig.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference driverRef =
    FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequestsRef =
    FirebaseDatabase.instance.reference().child("Ride request");
DatabaseReference requestsRef = FirebaseDatabase.instance
    .reference()
    .child("drivers")
    .child(currentUser.uid)
    .child("newRide");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light));
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Smart City Delivery App - Driver App',
        theme: ThemeData(
          fontFamily: 'Brand-Bold',
          primarySwatch: Colors.teal,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.idScreen
            : MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          CarDataScreen.idScreen: (context) => CarDataScreen()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
