import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = 'AIzaSyDI4X-fug0yawUaQ0I4xeNUXmaSRxlb5B8';

FirebaseUser currentFirebaseUser;

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);