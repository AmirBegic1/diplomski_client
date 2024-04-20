import 'dart:io' show Platform;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:diplomski_client/Models/RideInfo.dart';
import 'package:diplomski_client/Notifications/NotificationDialog.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mapConfig.dart';

class PushNotification {
  final FirebaseMessaging fbMessage = FirebaseMessaging();
  Future init(context) async {
    fbMessage.configure(onMessage: (Map<String, dynamic> message) async {
      getRequestInfo(getRideId(message), context);
    }, onLaunch: (Map<String, dynamic> message) async {
      getRequestInfo(getRideId(message), context);
    }, onResume: (Map<String, dynamic> message) async {
      getRequestInfo(getRideId(message), context);
    });
  }

  Future<String> getToken() async {
    String tok = await fbMessage.getToken();
    print("This is the token: $tok");
    print("----------------------------");
    driverRef.child(currentUser.uid).child("token").set(tok);
    fbMessage.subscribeToTopic("allDrivers");
    fbMessage.subscribeToTopic("allUsers");
  }

  String getRideId(Map<String, dynamic> message) {
    String rideId = "";
    if (Platform.isAndroid)
      rideId = message['data']['ride_request_id'];
    else
      rideId = message['ride_request_id'];
    return rideId;
  }

  void getRequestInfo(String rideId, BuildContext context) {
    newRequestsRef.child(rideId).once().then((DataSnapshot data) {
      if (data.value != null) {
        audioPlayer.open(Audio("sounds/ring.mp3"));
        audioPlayer.play();

        double pickUpLat =
            double.parse(data.value['pickup']['latitude'].toString());
        double pickUpLng =
            double.parse(data.value['pickup']['longitude'].toString());
        String pickUpAddress = data.value['pickup_address'].toString();

        double dropOffLat =
            double.parse(data.value['dropoff']['latitude'].toString());
        double dropOffLng =
            double.parse(data.value['dropoff']['longitude'].toString());
        String dropOffAddress = data.value['dropoff_address'].toString();

        String payment = data.value['payment_method'].toString();

        String rider_name = data.value["rider_name"];
        String rider_phone = data.value["rider_phone"];

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
      }
    });
  }
}
