import 'package:flutter/material.dart';
import 'package:diplomski_client/Assistant/processMethods.dart';
import 'package:diplomski_client/Models/RideHistory.dart';

// ignore: must_be_immutable
class RideHistoryItem extends StatelessWidget {
  RideHistory history;
  RideHistoryItem({required this.history});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 2),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.location_on, size: 25),
                      SizedBox(width: 18),
                      Expanded(
                          child: Container(
                              child: Text(history.pickUp!,
                                  style: TextStyle(fontSize: 18.0)))),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Icon(Icons.flag_outlined, size: 25),
                  SizedBox(width: 18),
                  Text(history.dropOff!, style: const TextStyle(fontSize: 18))
                ]),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(processMethods.formatRideDate(history.created_at!),
                            style: const TextStyle(color: Colors.grey)),
                        Text(
                            processMethods
                                .formatFares(history.fares.toString()),
                            style: const TextStyle(
                                fontFamily: "Brand-Bold",
                                fontSize: 18,
                                color: Colors.teal))
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
