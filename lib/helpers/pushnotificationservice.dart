//todo 1 (dokumentasi dari firebase_messaging)

//todo 2
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';

class PushNotificationService{
  final FirebaseMessaging fcm = FirebaseMessaging();

  //todo 3
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

  //todo 4 (next hometab)
  Future<String> getToken() async{
    String token = await fcm.getToken();
    print('token : $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);
    
    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');

  }

}