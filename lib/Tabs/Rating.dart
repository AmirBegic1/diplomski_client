import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:diplomski_client/DataHandler/appData.dart';
import 'package:diplomski_client/main.dart';
import 'package:diplomski_client/mapConfig.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage>
    with AutomaticKeepAliveClientMixin<RatingPage> {
  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    getRatings();
  }

  getRatings() async {
    driverRef
        .child(currentUser!.uid)
        .child("ratings")
        .get()
        .then((DataSnapshot data) {
      if (data.value != null) {
        double ratings = double.parse(data.value.toString()) /
            Provider.of<AppData>(context, listen: false).numberOfTrips!;
        setState(() {
          numberOfStars = ratings;
        });
        if (numberOfStars <= 1.5)
          setState(() {
            title = "Veoma loše";
          });
        else if (numberOfStars <= 2.5)
          setState(() {
            title = "Loše";
          });
        else if (numberOfStars <= 3.5)
          setState(() {
            title = "Dobar";
          });
        else if (numberOfStars <= 4.5)
          setState(() {
            title = "Vrlo dobar";
          });
        else
          setState(() {
            title = "Odličan";
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vaša trenutna ocjena",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: Colors.black87,
      body: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.all(5.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 22.0),
                Text(
                    "Vaša trenutna ocjena je: " +
                        (title == ""
                            ? "nije dostupno trenutno.\nNažalost imamo nekih problema oko vaše ocjene ili niste vozili do sada."
                            : numberOfStars.toStringAsFixed(2)),
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Brand-Regular",
                        color: Colors.white),
                    textAlign: TextAlign.center),
                title == ""
                    ? SizedBox()
                    : Column(children: [
                        SizedBox(height: 10.0),
                        // SmoothStarRating(
                        //     rating: numberOfStars,
                        //     color: Colors.teal,
                        //     borderColor: Colors.teal,
                        //     allowHalfRating: true,
                        //     starCount: 5,
                        //     size: 45,
                        //     isReadOnly: true),
                        SizedBox(height: 10.0),
                        Text(title,
                            style: const TextStyle(
                                fontSize: 35.0,
                                fontFamily: "Brand-Bold",
                                color: Colors.white))
                      ]),
                SizedBox(height: 22.0)
              ],
            ),
          )),
    );
  }
}
