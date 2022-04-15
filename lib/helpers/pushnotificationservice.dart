
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';

class PushNotificationService{
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future initialize() async{
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
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

//todo 1 (finish)
/**
 * Testing dengan postman
 * 'Content-Type': 'application/json',
 * 'Authorization': 'key=AAAAaFvDVjY:APA91bHMNMeFRHcJgO7DunLEkQXpAl3qxUSkeIxs5qjKFWB-0NAk7T0-0o4ac7EIRLEYdvgSgWJyVqR6xgytp3mnHF4kEQe3OJ_qzxBpxDIYBjtr9a5cp_WbeOWbc5fnyggrOI2x2_m9',
 *  url : https://fcm.googleapis.com/fcm/send
 *  body : (raw)
 *  {"notification": {"body": "this is a body","title": "this is a title"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done","ride_id" :$uid}, "to": "<FCM TOKEN>"}
 */