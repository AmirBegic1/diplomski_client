import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:diplomski_client/Models/Drivers.dart';
import 'package:diplomski_client/Models/Users.dart';

String mapKey = "AIzaSyDqXRdlvJcR5WVqfXlFjMxSYpD5o0eD9LQ";
User? user, currentUser;
Users? currentUsersOnline;
StreamSubscription<Position>? homePageSubscription;
StreamSubscription<Position>? rideSubscription;
final audioPlayer = AssetsAudioPlayer();
Position? currentPos;
Drivers? drivers;
String title = "";
double numberOfStars = 0.0;
String rideType = "";
