import 'package:flutter/material.dart';
import 'package:diplomski_client/Assistant/processMethods.dart';
import 'package:diplomski_client/mapConfig.dart';

class FareCollect extends StatelessWidget {
  final String paymentMethod;
  final double fare;

  FareCollect({required this.paymentMethod, required this.fare});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0),
              Text(
                "Ukupna cijena za ${rideType.toUpperCase()}",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 22.0),
              Text("${fare.toStringAsFixed(2)} BAM",
                  style: const TextStyle(
                      fontSize: 45.0,
                      fontFamily: "Brand-Regular",
                      color: Colors.teal)),
              SizedBox(height: 22.0),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                      "Ovo je ukupna cijena koju musterija treba platiti za obavljenu vožnju!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 13))),
              SizedBox(height: 30.0),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        processMethods.enableHomeLocationUpdate();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.black, width: 1.2),
                        ),
                      ),

                      // style: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30),
                      //     side: BorderSide(color: Colors.black, width: 1.2)),
                      // color: Colors.teal,
                      child: Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Preuzmi novac",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Icon(Icons.attach_money_outlined,
                                color: Colors.white, size: 26.0)
                          ],
                        ),
                      ))),
              SizedBox(height: 30.0)
            ],
          ),
        ));
  }
}
