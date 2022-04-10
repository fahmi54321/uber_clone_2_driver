import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_2_driver/brand_colors.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';
import 'package:uber_clone_2_driver/widgets/available_button.dart';
import 'package:uber_clone_2_driver/widgets/taxi_button.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  Position currentPosition;

  DatabaseReference tripRequestRef;

  void getCurrentPosition() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude,position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          initialCameraPosition: googlePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;

            getCurrentPosition();
          },
        ),

        Container(height: 135,width: double.infinity,color:BrandColors.colorPrimary,),

        Positioned(top: 60,left : 0,right: 0,child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                AvailableButton(
                    title: 'GO ONLINE',
                    color: BrandColors.colorOrange,
                    onPressed: () {

                      //todo 4 (finish)
                      GoOnline();

                    }),
              ],
        )),
      ],
    );
  }

  void GoOnline(){
    Geofire.initialize('driversAvailable'); //todo 1

    //todo 3
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude,);
    tripRequestRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/newtrip');
    tripRequestRef.set('waiting');
    tripRequestRef.onValue.listen((event) { });

  }

  // todo 2 Just change the 'Sites' with your pathToReference
  /*
  {
      "rules": {
        ".read":true,
        ".write": true,
          "Sites": {
          ".indexOn": ["g"]
        }
      }
    }
   */

}
