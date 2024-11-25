import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:diplomski_client/Assistant/processMethods.dart';
import 'package:diplomski_client/DataHandler/appData.dart';
import 'package:diplomski_client/mainscreen/RideHistoryScreen.dart';
import 'package:diplomski_client/mainscreen/registrationScreen.dart';

class EarningsPage extends StatefulWidget {
  @override
  _EarningsPageState createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    processMethods.getRidesHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vaši prihodi",
          style: TextStyle(color: Colors.white),
        ),
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(
        //     Icons.keyboard_arrow_left,
        //     color: Colors.white,
        //   ),
        // ),
        backgroundColor: Colors.black,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          Container(
              color:
                  Provider.of<AppData>(context, listen: false).numberOfTrips ==
                          0
                      ? Colors.black87
                      : Colors.teal,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 45),
                child: Column(children: [
                  const Text("Vaša ukupna zarada je:",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 15),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    Text(
                        "${double.parse(Provider.of<AppData>(context, listen: false).earnings!).toStringAsFixed(5)} BAM",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: "Brand-Bold"))
                  ]),
                ]),
              )),
          TextButton(
            // padding: EdgeInsets.all(0),
            onPressed: () {
              if (Provider.of<AppData>(context, listen: false).numberOfTrips !=
                  0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()));
              } else {
                displayToastMessage("Još niste odradili vožnje", context);
              }
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 30, 18),
              child: Row(
                children: [
                  Image.asset(
                    "images/car.png",
                    width: 70,
                    height: 40,
                  ),
                  SizedBox(width: 20),
                  const Text("Ukupan broj vožnji",
                      style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Container(
                      child: Text(
                        Provider.of<AppData>(context, listen: false)
                            .numberOfTrips
                            .toString(),
                        textAlign: TextAlign.end,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.teal),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(height: 2.0, thickness: 2.0)
        ],
      ),
    );
  }
}
