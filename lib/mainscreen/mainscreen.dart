import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:diplomski_client/Tabs/Earnings.dart';
import 'package:diplomski_client/Tabs/Home.dart';
import 'package:diplomski_client/Tabs/Profile.dart';
import 'package:diplomski_client/Tabs/Rating.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int index = 0;

  void onTabItemSelect(int newIndex) {
    setState(() {
      index = newIndex;
      tabController.index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [HomePage(), EarningsPage(), RatingPage(), ProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(
                icon: Icon(Icons.credit_card), label: "Earnings"),
            BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: "Ratings",
                backgroundColor: Colors.green),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account")
          ],
          unselectedItemColor: Colors.black26,
          selectedItemColor: Colors.teal,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 12.0),
          showUnselectedLabels: true,
          currentIndex: index,
          onTap: onTabItemSelect),
    );
  }
}
