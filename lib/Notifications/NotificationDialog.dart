import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_client/Assistant/processMethods.dart';
import 'package:diplomski_client/Models/RideInfo.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mainscreen/RideScreen.dart';
import 'package:diplomski_client/mainscreen/registrationScreen.dart';
import 'package:diplomski_client/mapConfig.dart';
import 'package:flutter/widgets.dart';

class NotificationDialog extends StatelessWidget {
  final RideInfo details;
  NotificationDialog({required this.details});
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: Colors.transparent,
        elevation: 1.0,
        child: Container(
            margin: EdgeInsets.all(2.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.0),
                Image.asset("images/car.png", width: 120.0),
                SizedBox(height: 18.0),
                Text("New Ride Request",
                    style: TextStyle(fontFamily: "Brand-Bold", fontSize: 22.0)),
                SizedBox(height: 10),
                Text("${details.rider_name} has requested a new ride",
                    style: TextStyle(fontFamily: "Brand-Bold", fontSize: 14)),
                SizedBox(height: 10),
                Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, size: 24.0),
                            SizedBox(width: 15.0),
                            Expanded(
                                child: Container(
                              child: Text(details.pickup_address!,
                                  style: TextStyle(fontSize: 16.0)),
                            ))
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.flag_outlined, size: 24.0),
                            SizedBox(width: 15.0),
                            Expanded(
                              child: Container(
                                child: Text(details.dropoff_address!,
                                    style: TextStyle(fontSize: 16.0)),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(color: Colors.red)),
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(
                                  color: Colors.red,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 25),
                              ),
                              onPressed: () {
                                audioPlayer.stop();
                                Navigator.pop(context);
                              },
                              child: Text("Cancel".toUpperCase(),
                                  style: TextStyle(fontSize: 14.0))),
                        ),
                        SizedBox(width: 25.0),
                        Expanded(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 25),
                                backgroundColor: Colors.green,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side:
                                        const BorderSide(color: Colors.green)),
                              ),
                              onPressed: () {
                                audioPlayer.stop();
                                checkAvailableRide(context);
                              },
                              child: Text("Accept".toUpperCase(),
                                  style: TextStyle(fontSize: 14.0))),
                        )
                      ],
                    )),
                SizedBox(height: 10.0)
              ],
            )));
  }

  void checkAvailableRide(context) async {
    await requestsRef.get().then((DataSnapshot snap) {
      Navigator.pop(context);
      String rideId = "";
      if (snap.exists) {
        rideId = snap.value.toString();
      } else {
        displayToastMessage("Ride does not exist", context);
      }
      if (rideId == details.ride_request_id) {
        requestsRef.set("accepted");
        processMethods.disableHomeLocationUpdate();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RideScreen(details: details)));
      } else if (rideId == "cancelled") {
        displayToastMessage("Ride has been cancelled", context);
      } else if (rideId == "timeout") {
        displayToastMessage("Ride request has expired", context);
      } else {
        displayToastMessage("Ride does not exist", context);
      }
    });
  }
}
