
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

        fetchRideInfo(getRideID(message)); //todo1

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        fetchRideInfo(getRideID(message)); //todo 2
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        fetchRideInfo(getRideID(message)); //todo 3

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


  //todo 4
  String getRideID(Map<String, dynamic> message){
    String rideID = '';

    if(Platform.isAndroid){
      rideID = message['data']['ride_id'];
      print('ride_id : $rideID');
    }

    return rideID;

  }

  //todo 5 (finish)
  void fetchRideInfo(String rideId){
    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('rideRequest/$rideId');

    rideRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null){
        double pickupLat = double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng = double.parse(snapshot.value['location']['longitude'].toString());
        String pickupAddress = snapshot.value['pickup_address'].toString();

        double destinationLat = double.parse(snapshot.value['destination']['latitude'].toString());
        double destinationLng = double.parse(snapshot.value['destination']['longitude'].toString());
        String destinationAddress = snapshot.value['destination_address'];
        String paymentMethod = snapshot.value['payment_method'];

        print(pickupAddress);
      }
    });
  }

}