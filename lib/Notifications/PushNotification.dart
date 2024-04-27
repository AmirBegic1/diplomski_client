import 'dart:io' show Platform;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:diplomski_client/Models/RideInfo.dart';
import 'package:diplomski_client/Notifications/NotificationDialog.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mapConfig.dart';

class PushNotification {
  final fbMessage = FirebaseMessaging.instance;
  Future init(context) async {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      getRequestInfo(getRideId(message.data), context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      getRequestInfo(getRideId(message as Map<String, dynamic>), context);
    });

    // FirebaseMessaging.onResume.listen((RemoteMessage message) async {
    //   getRequestInfo(getRideId(message.data), context);
    // });
  }

  Future<String> getToken() async {
    String? tok = await fbMessage.getToken();
    print("This is the token: $tok");
    print("----------------------------");
    driverRef.child(currentUser!.uid).child("token").set(tok);
    fbMessage.subscribeToTopic("allDrivers");
    fbMessage.subscribeToTopic("allUsers");
    return tok.toString();
  }

  String getRideId(Map<String, dynamic> message) {
    String rideId = "";
    if (Platform.isAndroid) {
      rideId = message['data']['ride_request_id'];
    } else {
      rideId = message['ride_request_id'];
    }
    return rideId;
  }

  void getRequestInfo(String rideId, BuildContext context) {
    newRequestsRef.child(rideId).get().then((DataSnapshot data) {
      if (data.value != null) {
        audioPlayer.open(Audio("sounds/ring.mp3"));
        audioPlayer.play();
//(data.child("phone").value.toString());
        double pickUpLat = double.parse(
            data.child("pickup").child('latitude').value.toString());
        double pickUpLng = double.parse(
            data.child("pickup").child('longitude').value.toString());
        String pickUpAddress = data.child("pickup_address").value.toString();

        double dropOffLat = double.parse(
            data.child("dropoff").child('latitude').value.toString());
        double dropOffLng = double.parse(
            data.child("dropoff").child('longitude').value.toString());
        String dropOffAddress = data.child("dropoff_address").value.toString();

        String payment = data.child("payment_method").value.toString();

        String rider_name = data.child("rider_name").toString();
        String rider_phone = data.child("rider_phone").toString();

        RideInfo details = RideInfo();

        details.ride_request_id = rideId;
        details.pickup_address = pickUpAddress;
        details.dropoff_address = dropOffAddress;
        details.pickup = LatLng(pickUpLat, pickUpLng);
        details.dropoff = LatLng(dropOffLat, dropOffLng);
        details.payment_method = payment;
        details.rider_name = rider_name;
        details.rider_phone = rider_phone;

        print("information :: ");
        print(details.pickup_address);
        print(details.dropoff_address);
        print("information :: ");

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) =>
                NotificationDialog(details: details));
      } else {
        print("NEEEEEEE RADIIIIIIIIIIIIIIIIIII");
      }
    });
  }
}
