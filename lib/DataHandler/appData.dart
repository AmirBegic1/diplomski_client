import 'package:flutter/material.dart';
import 'package:diplomski_client/Models/RideHistory.dart';

class AppData extends ChangeNotifier {
  String? earnings = "1";
  int? numberOfTrips = 0;
  List<String> tripKeys = [];
  List<RideHistory> historyKeys = [];

  Future<void> updateTotalEarnings(String newEarnings) async {
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
