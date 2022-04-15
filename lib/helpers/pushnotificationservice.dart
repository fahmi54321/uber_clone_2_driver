
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';

class PushNotificationService{
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future initialize() async{
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        //todo 1
        if(Platform.isAndroid){
          String rideID = message['data']['ride_id'];
          print('ride_id : $rideID');
        }

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        //todo 2
        if(Platform.isAndroid){
          String rideID = message['data']['ride_id'];
          print('ride_id : $rideID');
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        //todo 3 (finish)
        if(Platform.isAndroid){
          String rideID = message['data']['ride_id'];
          print('ride_id : $rideID');
        }
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

}