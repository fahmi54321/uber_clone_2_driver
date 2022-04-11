import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_2_driver/brand_colors.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';
import 'package:uber_clone_2_driver/widgets/available_button.dart';
import 'package:uber_clone_2_driver/widgets/confirm_sheet.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  Position currentPosition;

  DatabaseReference tripRequestRef;

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 4,
  );

  String availabitilyTitle = 'GO ONLINE'; //todo 1
  Color availabitilyColor = BrandColors.colorOrange; //todo 2
  bool isAvailable = false; //todo 3

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
                    title: availabitilyTitle,
                    color: availabitilyColor,
                    onPressed: () {
                      showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (BuildContext ctx) => ConfirmSheet(
                          title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE', //todo 4
                          subtitle: (!isAvailable) ? 'You are about become available to receive trip request' : 'You will stop receiving new trip requests', //todo 5
                          onPressed: (){
                            if(!isAvailable){ //todo 6
                              GoOnline();
                              getLocationUpdates();
                              Navigator.pop(context);

                              setState(() {
                                availabitilyTitle = 'GO OFFLINE';
                                availabitilyColor = BrandColors.colorGreen;
                                isAvailable = true;
                              });
                            }else{ //todo 7
                              GoOffline();
                              Navigator.pop(context);

                              setState(() {
                                availabitilyTitle = 'GO ONLiNE';
                                availabitilyColor = BrandColors.colorOrange;
                                isAvailable = false;
                              });
                            }
                          },
                        ),
                      );

                    }),
              ],
        )),
      ],
    );
  }

  void GoOnline(){
    Geofire.initialize('driversAvailable');

    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude,);
    tripRequestRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/newtrip');
    tripRequestRef.set('waiting');
    tripRequestRef.onValue.listen((event) { });
  }

  void GoOffline(){
    Geofire.removeLocation(currentFirebaseUser.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  void getLocationUpdates(){
    homeTabPositionStream = geolocator.getPositionStream(locationOptions).listen((Position position) {
      currentPosition = position;

      //todo 8 (finish)
      if(isAvailable){
        Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
      }

      LatLng pos = LatLng(position.latitude,position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }

}
