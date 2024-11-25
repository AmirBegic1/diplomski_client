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
import 'package:diplomski_client/Assistant/processMethods.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  Completer<GoogleMapController> _controllerGMap = Completer();

  GoogleMapController? GMap;

  Future<LocationPermission> permission = Geolocator.requestPermission();

  var locator = Geolocator();

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
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    currentPos = pos;
    LatLng latLngPosition = LatLng(pos.latitude, pos.longitude);
    CameraPosition cameraPos = CameraPosition(target: latLngPosition, zoom: 16);
    GMap?.animateCamera(CameraUpdate.newCameraPosition(cameraPos));
    var address = await processMethods.searchCoordinatesAddress(pos, context);
    print("Ovo je vaša adresa : " + address);
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

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(44.198013, 17.924672),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    return Stack(children: [
      GoogleMap(

          // polylines: Set<Marker>.of(polylines.value),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          buildingsEnabled: true,
          padding: EdgeInsets.only(top: 30, bottom: 20),
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
                padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                            "Sada ste online i dostupni vozačima", context);
                      } else {
                        setOffline();
                        setState(() {
                          statusColor = Colors.red;
                          status = "Offline";
                          isActive = false;
                        });
                        displayToastMessage(
                            "Sada ste oflajn, trenutno niste vidljivi drugim vozačima",
                            context);
                      }
                    },
                    // color: statusColor,
                    child: Padding(
                        padding: EdgeInsets.all(13.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$status  ',
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const Icon(Icons.phone_android,
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
    await Geofire.setLocation(
        currentUser!.uid, currentPos!.latitude, currentPos!.longitude);
    requestsRef.set("searching");
    requestsRef.onValue.listen((event) {});
  }

  Future<void> updateLocationAsync() async {
    homePageSubscription =
        Geolocator.getPositionStream().listen((Position p) async {
      // currentPos = p;
      if (isActive) {
        await Geofire.setLocation(
            currentUser!.uid, currentPos!.latitude, currentPos!.longitude);
      }
      LatLng pos = LatLng(currentPos!.latitude, currentPos!.longitude);
      print('OVDJE JE ZAPISANO');
      print(currentPos!.latitude);
      GMap?.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }

  Future<void> setOffline() async {
    Geofire.removeLocation(currentUser!.uid);
    requestsRef.onDisconnect();
    requestsRef.remove();
  }

  @override
  bool get wantKeepAlive => true;
}
