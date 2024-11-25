import 'dart:async';

import 'package:diplomski_client/Models/address.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:diplomski_client/Assistant/httpRequest.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:diplomski_client/DataHandler/appData.dart';
import 'package:diplomski_client/Models/Directions.dart';
import 'package:diplomski_client/Models/RideHistory.dart';

import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mapConfig.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class processMethods {
  static Future<Directions> getDirections(LatLng start, LatLng dest) async {
    String dir =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${dest.latitude},${dest.longitude}&key=$mapKey";
    var response = await httpRequest.getRequest(dir);
    if (response == "failed") {
      throw ('NE RADI NESTOOOOOOOOOOOOOOOOOOOOOO! ');
    }
    Directions directions = Directions();
    directions.checkpoints =
        response["routes"][0]["overview_polyline"]["points"];
    directions.distance = response["routes"][0]["legs"][0]["distance"]["value"];
    directions.timeTaken =
        response["routes"][0]["legs"][0]["duration"]["value"];
    directions.distanceText =
        response["routes"][0]["legs"][0]["distance"]["text"];
    directions.timeTakenText =
        response["routes"][0]["legs"][0]["duration"]["text"];
    return directions;
  }

  static double fareCalculate(Directions directions) {
    double timeTaken = (directions.timeTaken! / 60) * 0.20;
    double distanceTaken = (directions.distance! / 1000) * 0.20;
    double total = timeTaken + distanceTaken;
    if (rideType == "premium")
      return total * 1.5;
    else if (rideType == "bike")
      return total / 2.0;
    else
      return total;
  }

  static void disableHomeLocationUpdate() async {
    homePageSubscription?.pause();
    await Geofire.removeLocation(currentUser!.uid);
  }

  static void enableHomeLocationUpdate() async {
    homePageSubscription?.resume();
    await Geofire.setLocation(
        currentUser!.uid, currentPos!.latitude, currentPos!.longitude);
  }

  static void getRidesHistory(context) {
    driverRef
        .child(currentUser!.uid)
        .child("earnings")
        .get()
        .then((DataSnapshot data) {
      if (data.value != null) {
        String earnings = data.value.toString();
        // double earning = double.parse(earnings);
        // String gotovo = earning.toStringAsFixed(3);
//pogeldaj kao dole na ovo updatetripsList
        Provider.of<AppData>(context, listen: false)
            .updateTotalEarnings(earnings);
      }
    });

    driverRef
        .child(currentUser!.uid)
        .child("history")
        .get()
        .then((DataSnapshot data) {
      if (data.value != null) {
        Map<dynamic, dynamic> values = data.value as Map;
        int counter = values.length;
        Provider.of<AppData>(context, listen: false)
            .updateNumberOfTrips(counter);
        List<String> trips = [];
        values.forEach((key, value) {
          trips.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateTripsList(trips);
        getTripHistoryData(context);
      }
    });
  }

  static Future<void> getTripHistoryData(context) async {
    Provider.of<AppData>(context, listen: false).resetHistoryMap();
    var keys = Provider.of<AppData>(context, listen: false).tripKeys;
    for (String element in keys) {
      newRequestsRef.child(element).get().then((DataSnapshot data) {
        if (data.value != null) {
          var history = RideHistory.fromSnapshot(data);
          Provider.of<AppData>(context, listen: false)
              .updateHistoryList(history);
        }
      });
    }
  }

  static Future<String> searchCoordinatesAddress(Position pos, context) async {
    String place = "";
    String target =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=$mapKey";
    var response = await httpRequest.getRequest(target);
    if (response != "failed") {
      place = response["results"][0]["address_components"][1]["long_name"] +
          ' ' +
          response["results"][0]["address_components"][0]["long_name"] +
          ", " +
          response["results"][0]["address_components"][2]["long_name"];
      Address userPickup = Address();
      userPickup.lng = pos.longitude;
      userPickup.lat = pos.latitude;
      userPickup.name = place;
      // Provider.of<AppData>(context, listen: false).updatePickup(userPickup);
    }
    return place;
  }

  // ignore: unused_element
  static String formatFares(String fares) {
    String fare = double.parse(fares).toStringAsFixed(5);
    return fare;
  }

  static String formatRideDate(String date) {
    DateTime time = DateTime.parse(date);
    String format =
        "${DateFormat.MMMd().format(time)}, ${DateFormat.y().format(time)} - ${DateFormat.jm().format(time)}";
    return format;
  }
}
