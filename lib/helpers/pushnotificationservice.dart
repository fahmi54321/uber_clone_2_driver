
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
 * Testing dengan firebase console > cloud messaging
 * How to ?
 * 1. Click New notification
 * 2. Isikan notification title dan notification text
 * 3. pada tab target bagian topic pilih alldrivers
 * 4. pada tab scheduling pilih now
 * 5. sound enabled
 * 6. and klik review lalu publish
 *
 *  * How to testing dengan token?
 * 1. Click New notification
 * 2. Isikan notification title dan notification text
 * 3. klik test message
 * 4. masukkan token
 * 5. and klik test
 */