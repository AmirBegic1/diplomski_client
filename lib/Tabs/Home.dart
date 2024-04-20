import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:diplomski_client/Models/Drivers.dart';
import 'package:diplomski_client/Notifications/PushNotification.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mainscreen/registrationScreen.dart';
import 'package:diplomski_client/mapConfig.dart';

class HomePage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(44.2025046, 17.8979634),
    zoom: 14.4746,
  );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  Completer<GoogleMapController> _controllerGMap = Completer();

  late GoogleMapController GMap;

  var Locator = Geolocator();

  String status = "Offline";

  Color statusColor = Colors.red;

  bool isActive = false;

  @override
  void initState() {
    super.initState();
    getDriverInfo();
  }

  getRideType() {
    driverRef
        .child(currentUser!.uid)
        .child("car_data")
        .child("type")
        .get()
        .then((DataSnapshot data) {
      if (data.value != null) {
        setState(() {
          rideType = data.value.toString();
        });
      }
    });
  }

  void locateUser() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPos = pos;
    LatLng latLngPosition = LatLng(pos.latitude, pos.longitude);
    CameraPosition cameraPos =
        new CameraPosition(target: latLngPosition, zoom: 16);
    GMap.animateCamera(CameraUpdate.newCameraPosition(cameraPos));
    //String address = await processMethods.searchCoordinatesAddress(pos, context);
    //print("This is your address : " + address);
  }

  void getDriverInfo() async {
    currentUser = FirebaseAuth.instance.currentUser!;
    driverRef.child(currentUser!.uid).get().then((DataSnapshot data) {
      if (data.value != null) {
        drivers = Drivers.fromSnapshot(data);
      }
    });
    PushNotification pushNotification = PushNotification();
    pushNotification.init(context);
    pushNotification.getToken();
    getRideType();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    return Stack(children: [
      GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomePage._kGooglePlex,
          myLocationEnabled: true,
          buildingsEnabled: true,
          padding: EdgeInsets.only(top: 20),
          onMapCreated: (GoogleMapController controller) {
            _controllerGMap.complete(controller);
            GMap = controller;
            locateUser();
          }),
      Positioned(
        bottom: 15.0,
        left: 0.0,
        right: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                    style: TextButton.styleFrom(
                      shadowColor: statusColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.black, width: 1.2)),
                    ),
                    onPressed: () {
                      if (!isActive) {
                        setOnline();
                        updateLocationAsync();
                        setState(() {
                          statusColor = Colors.green;
                          status = "Online";
                          isActive = true;
                        });
                        displayToastMessage(
                            "You are online now and visible to the riders",
                            context);
                      } else {
                        setOffline();
                        setState(() {
                          statusColor = Colors.red;
                          status = "Offline";
                          isActive = false;
                        });
                        displayToastMessage(
                            "You are offline now. The options are still available, but you're not visible to others",
                            context);
                      }
                    },
                    // color: statusColor,
                    child: Padding(
                        padding: EdgeInsets.all(13.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(status + '  ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Icon(Icons.phone_android,
                                  color: Colors.white, size: 21.0)
                            ]))))
          ],
        ),
      )
    ]);
  }

  void setOnline() async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPos = pos;
    Geofire.initialize("driversOnline");
    Geofire.setLocation(
        currentUser!.uid, currentPos!.latitude, currentPos!.longitude);
    requestsRef.set("searching");
    requestsRef.onValue.listen((event) {});
  }

  void updateLocationAsync() {
    homePageSubscription = Geolocator.getPositionStream().listen((Position p) {
      currentPos = p;
      if (isActive)
        Geofire.setLocation(currentUser!.uid, p.latitude, p.longitude);
      LatLng pos = LatLng(p.latitude, p.longitude);
      GMap.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }

  void setOffline() {
    Geofire.removeLocation(currentUser!.uid);
    requestsRef.onDisconnect();
    requestsRef.remove();
  }

  @override
  bool get wantKeepAlive => true;
}
