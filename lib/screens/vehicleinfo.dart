import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_2_driver/brand_colors.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';
import 'package:uber_clone_2_driver/screens/mainpage.dart';
import 'package:uber_clone_2_driver/widgets/progress_dialog.dart';
import 'package:uber_clone_2_driver/widgets/taxi_button.dart';

class VehicleInfoPage extends StatefulWidget {
  static const String id = 'vehicleinfo';

  @override
  _VehicleInfoPageState createState() => _VehicleInfoPageState();
}

class _VehicleInfoPageState extends State<VehicleInfoPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>(); // todo 1

  //todo 2
  var carModelController = TextEditingController();

  var carColorController = TextEditingController();

  var vechileNumberController = TextEditingController();

  @override
  void dispose() { //todo 3
    carModelController.dispose();
    carColorController.dispose();
    vechileNumberController.dispose();
    super.dispose();
  }

  //todo 4
  void showSnackBar(String title){
    final snackbar = SnackBar(content: Text(title,textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),);
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  //todo 12
  void updateProfile(){

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) => ProgressDialog(status: 'Registering you...'),
    );

    String id = currentFirebaseUser.uid;
    DatabaseReference driverRef = FirebaseDatabase.instance.reference().child('drivers/$id/vehicle_details');

    Map map = {
      'car_color' : carColorController.text,
      'car_model' : carModelController.text,
      'vehicle_number' : vechileNumberController.text,
    };

    driverRef.set(map);

    Navigator.pop(context); // close dialog
    
    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, //todo 5
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Image.asset('images/logo.png', height: 110, width: 110),
              Padding(
                padding: const EdgeInsets.fromLTRB(30,20,30,30),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Enter vehicle details',style: TextStyle(fontFamily: 'Brand-Bold',fontSize: 22,),),
                    TextField(
                      controller: carModelController, //todo 6
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Car Model',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: carColorController, //todo 7
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Car color',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: vechileNumberController, //todo 8
                      decoration: InputDecoration(
                        labelText: 'Vehicle number',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 40),
                    TaxiButton(title: 'PROCCED', color: BrandColors.colorGreen, onPressed: () async{

                      //todo 9 (next globalvariabel)
                      var connectivityResult = await Connectivity().checkConnectivity();
                      if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                        showSnackBar('No internet connectivity');
                      }

                      if(carModelController.text.length < 3){
                        showSnackBar('Please provide a valid car model');
                        return;
                      }
                      if(carColorController.text.length < 3){
                        showSnackBar('Please provide a valid car color');
                        return;
                      }

                      if(vechileNumberController.text.length < 3){
                        showSnackBar('Please provide a valid vehicle number');
                        return;
                      }

                      //todo 13 (next registerpage)
                      updateProfile();


                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
