import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:diplomski_client/DataHandler/appData.dart';
import 'package:diplomski_client/widgets/RideHistoryItem.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text("Trip history"),
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left),
          )),
      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) => RideHistoryItem(
          history:
              Provider.of<AppData>(context, listen: false).historyKeys[index],
        ),
        separatorBuilder: (BuildContext context, int index) =>
            Divider(thickness: 3.0, height: 3.0),
        itemCount:
            Provider.of<AppData>(context, listen: false).historyKeys.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
