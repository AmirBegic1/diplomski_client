import 'package:flutter/material.dart';
import 'package:diplomski_client/Models/RideHistory.dart';
import 'package:diplomski_client/Models/address.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  int numberOfTrips = 0;
  List<String> tripKeys = [];
  List<RideHistory> historyKeys = [];

  void updateTotalEarnings(String newEarnings) {
    earnings = newEarnings;
    notifyListeners();
  }

  void updateNumberOfTrips(int counter) {
    numberOfTrips = counter;
    notifyListeners();
  }

  void updateTripsList(List<String> newKeys) {
    tripKeys = newKeys;
    notifyListeners();
  }

  void resetHistoryMap() {
    historyKeys = [];
    notifyListeners();
  }

  void updateHistoryList(RideHistory eachHistory) {
    historyKeys.add(eachHistory);
    notifyListeners();
  }
}
