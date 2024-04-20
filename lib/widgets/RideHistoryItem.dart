import 'package:flutter/material.dart';
import 'package:diplomski_client/Assistant/processMethods.dart';
import 'package:diplomski_client/Models/RideHistory.dart';

class RideHistoryItem extends StatelessWidget {
  final RideHistory history;
  RideHistoryItem({this.history});
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
                              child: Text(history.pickUp,
                                  style: TextStyle(fontSize: 18.0)))),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Icon(Icons.flag_outlined, size: 25),
                  SizedBox(width: 18),
                  Text(history.dropOff, style: TextStyle(fontSize: 18))
                ]),
                SizedBox(height: 10),
                FlatButton(
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(processMethods.formatRideDate(history.created_at),
                            style: TextStyle(color: Colors.grey)),
                        Text("${history.fares == null ? 0 : history.fares} BAM",
                            style: TextStyle(
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
