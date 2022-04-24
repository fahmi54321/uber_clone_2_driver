
import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitHelper{

  //todo 1 (next newtripspage)
  static double getMarkerRotation(sourceLat,sourceLng,destinationLat,destinationLng){

    // remember (LatLngg nya form maps_toolkit)
    var rotation = SphericalUtil.computeHeading(
        LatLng(sourceLat, sourceLng),
        LatLng(
          destinationLat,
          destinationLng,
        ));

    return rotation;
  }
}