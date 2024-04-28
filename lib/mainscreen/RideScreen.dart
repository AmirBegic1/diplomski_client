import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:diplomski_client/Assistant/Mapkit.dart';
import 'package:diplomski_client/Assistant/processMethods.dart';
import 'package:diplomski_client/Models/RideInfo.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mapConfig.dart';
import 'package:diplomski_client/widgets/FareCollect.dart';
import 'package:diplomski_client/widgets/progressDialog.dart';
import 'package:url_launcher/url_launcher.dart';

class RideScreen extends StatefulWidget {
  final RideInfo details;

  RideScreen({required this.details});

  static final CameraPosition startPos = CameraPosition(
    target: LatLng(43.8938256, 18.312952),
    zoom: 14,
  );

  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  Completer<GoogleMapController> _controllerGMap = Completer();
  GoogleMapController? RideGMap;
  Set<Marker> marksSet = Set<Marker>();
  Set<Circle> circlesSet = Set<Circle>();
  Set<Polyline> lines = Set<Polyline>();
  List<LatLng> coords = [];
  PolylinePoints points = PolylinePoints();
  double mapPadding = 0;
  var geolocator = Geolocator();
  var options = LocationSettings(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor? animateIcon;
  Position? myPos;
  String status = "accepted";
  String timeTaken = "";
  bool inRequest = false;
  String btnValue = "Arrived";
  Color btnColor = Colors.teal;
  Timer? timer;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    acceptRequest();
  }

  void createMarkerIcon() {
    if (animateIcon == null) {
      ImageConfiguration img =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(img, "images/car_marker.png")
          .then((value) {
        animateIcon = value;
      });
    }
  }

  void updateLocationMarker() {
    LatLng oldCoords = LatLng(0, 0);
    rideSubscription = Geolocator.getPositionStream().listen((Position p) {
      currentPos = p;
      myPos = p;
      LatLng markerPos = LatLng(p.latitude, p.longitude);
      var rotate = MapKit.getMarkerRotation(oldCoords.latitude,
          oldCoords.longitude, myPos?.latitude, myPos?.longitude);
      Marker animation = Marker(
          markerId: MarkerId("animation"),
          position: markerPos,
          icon: animateIcon!,
          rotation: rotate.toDouble(),
          infoWindow: InfoWindow(title: "Current location"));
      setState(() {
        CameraPosition cameraPos = CameraPosition(target: markerPos, zoom: 17);
        RideGMap?.animateCamera(CameraUpdate.newCameraPosition(cameraPos));
        marksSet.removeWhere((marker) => marker.markerId.value == "animation");
        marksSet.add(animation);
      });
      oldCoords = markerPos;
      updateCurrentDetails();
      String? rideId = widget.details.ride_request_id;
      Map location = {
        "latitude": currentPos!.latitude.toString(),
        "longitude": currentPos!.longitude.toString(),
      };
      newRequestsRef.child(rideId!).child("driver_location").set(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    createMarkerIcon();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              padding: EdgeInsets.only(top: 20, bottom: mapPadding),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: RideScreen.startPos,
              myLocationEnabled: true,
              markers: marksSet,
              circles: circlesSet,
              polylines: lines,
              onMapCreated: (GoogleMapController controller) async {
                _controllerGMap.complete(controller);
                RideGMap = controller;
                setState(() {
                  mapPadding = 285.0;
                });
                var currLatLng =
                    LatLng(currentPos!.latitude, currentPos!.longitude);
                var pickLatLng = widget.details.pickup;
                await getDirections(currLatLng, pickLatLng!);
                updateLocationMarker();
              }),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                height: 290.0,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    children: [
                      Text(
                        "$timeTaken remaining",
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Brand-Bold",
                            color: Colors.white),
                      ),
                      SizedBox(height: 6.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.details.rider_name!,
                              style: TextStyle(
                                  fontFamily: "Brand-Bold",
                                  fontSize: 28.0,
                                  color: Colors.white)),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                color: Colors.transparent,
                                minWidth: 0,
                                onPressed: () async {
                                  launch(
                                      ("tel://${widget.details.rider_phone}"));
                                },
                                child: Icon(Icons.call, color: Colors.teal)),
                          )
                        ],
                      ),
                      SizedBox(height: 26.0),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 16.0, color: Colors.teal),
                          SizedBox(width: 18.0),
                          Expanded(
                              child: Container(
                            child: Text(
                              widget.details.pickup_address!,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Icon(Icons.flag_outlined,
                              size: 16.0, color: Colors.teal),
                          SizedBox(width: 18.0),
                          Expanded(
                              child: Container(
                            child: Text(widget.details.dropoff_address!,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.white),
                                overflow: TextOverflow.ellipsis),
                          ))
                        ],
                      ),
                      SizedBox(height: 26.0),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                backgroundColor: btnColor,
                              ),
                              onPressed: () async {
                                if (status == "accepted") {
                                  status = "arrived";
                                  String rideId =
                                      widget.details.ride_request_id!;
                                  newRequestsRef
                                      .child(rideId)
                                      .child("status")
                                      .set(status);
                                  setState(() {
                                    btnValue = "Start trip";
                                    btnColor = Colors.green;
                                  });
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          ProgressDialog(
                                              message: "Please wait"));
                                  await getDirections(widget.details.pickup!,
                                      widget.details.dropoff!);
                                  Navigator.pop(context);
                                } else if (status == "arrived") {
                                  status = "riding";
                                  String rideId =
                                      widget.details.ride_request_id!;
                                  newRequestsRef
                                      .child(rideId)
                                      .child("status")
                                      .set(status);
                                  setState(() {
                                    btnValue = "End trip";
                                    btnColor = Colors.redAccent;
                                  });
                                  initRideTimer();
                                } else if (status == "riding") {
                                  endRide();
                                }
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(17.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(btnValue,
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        Icon(Icons.check,
                                            color: Colors.white, size: 26.0)
                                      ]))))
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  Future<void> getDirections(LatLng pickLatLng, LatLng dropLatLng) async {
    print("---------------------------------------------------------------");
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Getting directions. Please wait"));
    var directions = await processMethods.getDirections(pickLatLng, dropLatLng);
    Navigator.pop(context);
    print("These are the encoded points for the destination: ");
    print(directions.checkpoints);
    PolylinePoints points = PolylinePoints();
    List<PointLatLng> pointsDecoded =
        points.decodePolyline(directions.checkpoints!);
    coords.clear();
    if (pointsDecoded.isNotEmpty) {
      pointsDecoded.forEach((PointLatLng point) {
        coords.add(LatLng(point.latitude, point.longitude));
      });
    }

    lines.clear();
    setState(() {
      Polyline polyline = Polyline(
          color: Colors.pink,
          polylineId: PolylineId("directions"),
          jointType: JointType.round,
          points: coords,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      lines.add(polyline);
    });
    LatLngBounds bounds;
    if (pickLatLng.latitude > dropLatLng.latitude &&
        pickLatLng.longitude > dropLatLng.longitude) {
      bounds = LatLngBounds(southwest: dropLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > dropLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, dropLatLng.longitude),
          northeast: LatLng(dropLatLng.latitude, pickLatLng.longitude));
    } else if (pickLatLng.latitude > dropLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(dropLatLng.latitude, pickLatLng.longitude),
          northeast: LatLng(pickLatLng.latitude, dropLatLng.longitude));
    } else {
      bounds = LatLngBounds(southwest: pickLatLng, northeast: dropLatLng);
    }
    RideGMap?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
    Marker pickUpMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: pickLatLng,
        markerId: MarkerId("PickUpMarker"));
    Marker dropOffMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: dropLatLng,
        markerId: MarkerId("DropOffMarker"));
    setState(() {
      marksSet.add(pickUpMarker);
      marksSet.add(dropOffMarker);
    });
    Circle pickCircle = Circle(
        fillColor: Colors.blueAccent,
        center: pickLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.yellowAccent,
        circleId: CircleId("PickUpMarker"));
    Circle dropCircle = Circle(
        fillColor: Colors.deepPurple,
        center: dropLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.deepPurple,
        circleId: CircleId("DropOffMarker"));
    setState(() {
      circlesSet.add(pickCircle);
      circlesSet.add(dropCircle);
    });
  }

  void acceptRequest() {
    String rideId = widget.details.ride_request_id!;
    newRequestsRef.child(rideId).child("status").set("accepted");
    newRequestsRef.child(rideId).child("driver_name").set(drivers?.name);
    newRequestsRef.child(rideId).child("driver_phone").set(drivers?.phone);
    newRequestsRef.child(rideId).child("driver_id").set(drivers?.id);
    newRequestsRef
        .child(rideId)
        .child("car_details")
        .set('${drivers?.car_color} - ${drivers?.car_model}');
    Map location = {
      "latitude": currentPos?.latitude.toString(),
      "longitude": currentPos?.longitude.toString(),
    };
    newRequestsRef.child(rideId).child("driver_location").set(location);
    driverRef.child(currentUser!.uid).child("history").child(rideId).set(true);
  }

  void updateCurrentDetails() async {
    if (!inRequest) {
      inRequest = true;
      var position = LatLng(myPos!.latitude, myPos!.longitude);
      LatLng dest;
      if (status == "accepted") {
        dest = widget.details.pickup!;
      } else {
        dest = widget.details.dropoff!;
      }
      var directions = await processMethods.getDirections(position, dest);
      setState(() {
        timeTaken = directions.timeTakenText!;
      });
      inRequest = false;
    }
  }

  void initRideTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      counter++;
    });
  }

  endRide() async {
    timer?.cancel();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Please wait"));
    var driverPos = LatLng(myPos!.latitude, myPos!.longitude);
    var dirs =
        await processMethods.getDirections(widget.details.pickup!, driverPos);
    Navigator.pop(context);
    double fareTotal = processMethods.fareCalculate(dirs);
    String rideId = widget.details.ride_request_id!;
    newRequestsRef.child(rideId).child("fares").set(fareTotal.toString());
    newRequestsRef.child(rideId).child("status").set("done");
    rideSubscription?.cancel();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FareCollect(
            paymentMethod: widget.details.payment_method!, fare: fareTotal));
    saveFareAmount(fareTotal);
  }

  void saveFareAmount(double fare) {
    driverRef
        .child(currentUser!.uid)
        .child("earnings")
        .get()
        .then((DataSnapshot data) {
      double totalFare;
      if (data.value != null)
        totalFare = fare + double.parse(data.value.toString());
      else
        totalFare = fare;
      driverRef
          .child(currentUser!.uid)
          .child("earnings")
          .set(totalFare.toStringAsFixed(2));
    });
  }
}
