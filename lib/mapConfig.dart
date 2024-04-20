import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:diplomski_client/Models/Drivers.dart';
import 'package:diplomski_client/Models/Users.dart';

String mapKey = "YOUR_MAP_API_KEY";
User user;
Users currentUsersOnline;
User currentUser;
StreamSubscription<Position> homePageSubscription;
StreamSubscription<Position> rideSubscription;
final audioPlayer = AssetsAudioPlayer();
Position currentPos;
Drivers drivers;
String title = "";
double numberOfStars = 0.0;
String rideType = "";
