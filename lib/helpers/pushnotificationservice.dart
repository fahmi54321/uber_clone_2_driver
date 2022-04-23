
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_2_driver/datamodels/tripdetails.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';
import 'package:uber_clone_2_driver/widgets/notification_dialog.dart';
import 'package:uber_clone_2_driver/widgets/progress_dialog.dart';

class PushNotificationService{
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future initialize(context) async{
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        fetchRideInfo(getRideID(message),context);

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        fetchRideInfo(getRideID(message),context);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        fetchRideInfo(getRideID(message),context);

      },
    );
  }

  Future<String> getToken() async{
    String token = await fcm.getToken();
    print('token : $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);
    
    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');

  }


  String getRideID(Map<String, dynamic> message){
    String rideID = '';

    if(Platform.isAndroid){
      rideID = message['data']['ride_id'];
      print('ride_id : $rideID');
    }

    return rideID;

  }

  void fetchRideInfo(String rideId,context){

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) => ProgressDialog(status: 'Fetching details'),
    );

    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('rideRequest/$rideId');

    rideRef.once().then((DataSnapshot snapshot) {

      Navigator.pop(context);

      if(snapshot.value != null){

        //todo 2 (next notification_dialog)
        assetAudioPlayer.open(Audio('sounds/alert.mp3'));
        assetAudioPlayer.play();

        double pickupLat = double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng = double.parse(snapshot.value['location']['longitude'].toString());
        String pickupAddress = snapshot.value['pickup_address'].toString();

        double destinationLat = double.parse(snapshot.value['destination']['latitude'].toString());
        double destinationLng = double.parse(snapshot.value['destination']['longitude'].toString());
        String destinationAddress = snapshot.value['destination_address'];
        String paymentMethod = snapshot.value['payment_method'];

        TripDetails tripDetails = TripDetails();
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.destination = LatLng(destinationLat, destinationLng);
        tripDetails.paymentMethod = paymentMethod;
        tripDetails.rideID = rideId;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext ctx) => NotificationDialog(
            tripDetails: tripDetails,
          ),
        );
      }
    });
  }

}