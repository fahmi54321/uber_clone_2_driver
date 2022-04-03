import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_2_driver/screens/loginpage.dart';
import 'package:uber_clone_2_driver/screens/mainpage.dart';
import 'package:uber_clone_2_driver/screens/registerpage.dart';
import 'package:uber_clone_2_driver/screens/vehicleinfo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:448216127030:android:86b118e2051acfc662aa97',
      gcmSenderID: '297855924061',
      databaseURL: 'https://uber-d5e16-default-rtdb.firebaseio.com',
    )
        : const FirebaseOptions(
      googleAppID: '1:448216127030:android:86b118e2051acfc662aa97',
      apiKey: 'AIzaSyD12_TVFRT2F_k-QMrfFt7vUpYhITwoHYQ',
      databaseURL: 'https://uber-d5e16-default-rtdb.firebaseio.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Brand-Reguler',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginPage.id,
      routes: {
        MainPage.id : (context) => MainPage(),
        LoginPage.id : (context) => LoginPage(),
        RegisterPage.id : (context) => RegisterPage(),
        VehicleInfoPage.id : (context) => VehicleInfoPage(),
      },
    );
  }
}
