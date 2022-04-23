import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uber_clone_2_driver/brand_colors.dart';
import 'package:uber_clone_2_driver/datamodels/tripdetails.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';
import 'package:uber_clone_2_driver/screens/newtripspage.dart';
import 'package:uber_clone_2_driver/widgets/TaxiOutlineButton.dart';
import 'package:uber_clone_2_driver/widgets/progress_dialog.dart';

class NotificationDialog extends StatelessWidget {

  final TripDetails tripDetails;

  NotificationDialog({this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30),
            Image.asset('images/taxi.png', width: 100),
            SizedBox(height: 16),
            Text(
              'NEW TRIP REQUEST',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('images/pickicon.png', height: 16, width: 16),
                      SizedBox(width: 18),
                      Expanded(child: Container(child: Text(tripDetails.pickupAddress, style: TextStyle(fontSize: 18)))),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('images/desticon.png', height: 16, width: 16),
                      SizedBox(width: 18),
                      Expanded(child: Container(child: Text(tripDetails.destinationAddress, style: TextStyle(fontSize: 18)))),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: 'DECLINE',
                        color: BrandColors.colorPrimary,
                        onPressed: () {
                          assetAudioPlayer.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: 'ACCEPT',
                        color: BrandColors.colorPrimary,
                        onPressed: () {
                          assetAudioPlayer.stop();
                          checkAvailability(context); //todo 2
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  //todo 1
  void checkAvailability(context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Accepting request'));

    DatabaseReference newRideRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/newtrip');
    newRideRef.once().then((DataSnapshot snapshot) {

      Navigator.pop(context);
      Navigator.pop(context);

      String thisRideID = '';
      if(snapshot.value != null){
        thisRideID= snapshot.value.toString();
      }else{
        Toast.show("ride not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }

      if(thisRideID == tripDetails.rideID){
        newRideRef.set('accepted');
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewTripsPage(tripDetails: tripDetails,)));
      }else if(thisRideID == 'cancelled'){
        Toast.show("ride has been cancelled", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }else if(thisRideID == 'timeout'){
        Toast.show("ride has time out", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }else{
        Toast.show("ride not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    });
  }
}
