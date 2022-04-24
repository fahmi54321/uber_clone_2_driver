import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_2_driver/datamodels/drivers.dart';

String mapKey = 'AIzaSyDI4X-fug0yawUaQ0I4xeNUXmaSRxlb5B8';

FirebaseUser currentFirebaseUser;

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

StreamSubscription<Position> homeTabPositionStream;

final assetAudioPlayer = AssetsAudioPlayer();
Position currentPosition;
DatabaseReference rideRef;
Driver currentDriverInfo;

