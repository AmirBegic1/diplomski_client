import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mainscreen/loginScreen.dart';
import 'package:diplomski_client/mainscreen/registrationScreen.dart';
import 'package:diplomski_client/mapConfig.dart';

/*
  drivers - driver data
  title - describes the rating of driver
 */

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text(
            "O vama",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    const CircleAvatar(
                        backgroundImage: AssetImage("images/user_icon.png")),
                    Positioned(
                      right: -16,
                      bottom: 0,
                      child: Align(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: const BorderSide(color: Colors.white)),
                              backgroundColor: const Color(0xFFF5F6F9),
                            ),
                            onPressed: () {},
                            child: const Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(drivers!.name!,
                  style: const TextStyle(fontSize: 30, color: Colors.white)),
              SizedBox(height: 20),
              ProfileInfo(
                  type: "Profil ID",
                  text: drivers!.id,
                  icon: Icons.perm_identity),
              ProfileInfo(
                type: "Email addresa",
                text: drivers!.email!,
                icon: Icons.email,
              ),
              ProfileInfo(
                type: "Broj telefona",
                text: drivers!.phone!,
                icon: Icons.phone,
              ),
              ProfileInfo(
                type: "Vaše auto",
                text: drivers!.car_color! + ' ' + drivers!.car_model!,
                icon: Icons.car_rental,
                trailingIcon: Icons.add,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(
                                    color: Colors.black87, width: 1.9)),
                          ),
                          onPressed: () {
                            Geofire.removeLocation(currentUser!.uid);
                            requestsRef.onDisconnect();
                            requestsRef.remove();
                            // requestsRef = null;
                            FirebaseAuth.instance.signOut();
                            displayToastMessage(
                                "Upravo ste odjavljeni!", context);
                            Navigator.pushNamedAndRemoveUntil(context,
                                LoginScreen.idScreen, (route) => false);
                          },
                          // ignore: prefer_const_constructors
                          child: Padding(
                              padding: EdgeInsets.all(13.0),
                              child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Odjavi se   ",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Icon(Icons.exit_to_app,
                                        color: Colors.white, size: 21.0)
                                  ]))))
                ],
              ),
            ])));
  }
}

// ignore: must_be_immutable
class ProfileInfo extends StatelessWidget {
  final String? text, type;
  final IconData? icon, trailingIcon;
  final Color? color;
  Function()? onPressed;

  ProfileInfo(
      {super.key,
      this.text,
      this.icon,
      this.onPressed,
      this.type,
      this.trailingIcon,
      this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: ListTile(
              leading: Icon(icon,
                  color: color != null ? color : Colors.black87, size: 40),
              title: Text(
                type!,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontFamily: "Brand-Bold"),
              ),
              subtitle: Text(
                text!,
                style: const TextStyle(
                    color: Colors.teal, fontSize: 12, fontFamily: "Brand-Bold"),
              ),
              trailing: Icon(trailingIcon, color: Colors.teal)),
        ));
  }
}
