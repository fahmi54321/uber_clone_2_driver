import 'dart:math';

import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_2_driver/datamodels/directiondetails.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';
import 'package:uber_clone_2_driver/helpers/requesthelpers.dart';

class HelperMethods{

  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async{
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';


    var response = await RequestHelper.getRequest(url);

    if(response == 'failed'){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];
    directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.encodePoints = response['routes'][0]['overview_polyline']['points'];

    return directionDetails;

  }

  static int estimateFares(DirectionDetails details){
    // per km = $0.3
    // per minute = $0.2
    // base fare = $3

    double baseFare = 3;
    double distanceFare = (details.distanceValue/1000) * 0.3;
    double timeFare = (details.durationValue/60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();

  }

  static double generateRandomNumber(int max){
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  //todo 1
  static void disableHomeTabLocationUpdates(){
    homeTabPositionStream.pause();
    Geofire.removeLocation(currentFirebaseUser.uid);
  }

  //todo 2 (next notifiation_dialog)
  static void enableHomeTabLocationUpdates(){
    homeTabPositionStream.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
  }

}