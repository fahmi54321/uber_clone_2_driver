import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_2_driver/brand_colors.dart';
import 'package:uber_clone_2_driver/datamodels/tripdetails.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';
import 'package:uber_clone_2_driver/helpers/helpersmethod.dart';
import 'package:uber_clone_2_driver/widgets/progress_dialog.dart';
import 'package:uber_clone_2_driver/widgets/taxi_button.dart';

class NewTripsPage extends StatefulWidget {

  final TripDetails tripDetails;
  NewTripsPage({this.tripDetails});

  @override
  _NewTripsPageState createState() => _NewTripsPageState();
}


class _NewTripsPageState extends State<NewTripsPage> {

  GoogleMapController rideMapController;
  Completer<GoogleMapController> _controller = Completer();

  //todo 1
  double mapPaddingBottom = 0;
  Set<Marker>_markers = Set<Marker>();
  Set<Circle>_circles = Set<Circle>();
  Set<Polyline>_polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: googlePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            trafficEnabled: true,
            mapType: MapType.normal,
            padding: EdgeInsets.only(bottom: mapPaddingBottom),
            circles: _circles, //todo 2
            markers: _markers, //todo 3
            polylines: _polylines, //todo 4
            onMapCreated: (GoogleMapController controller) async{
              _controller.complete(controller);
              rideMapController = controller;

              setState(() {
                mapPaddingBottom = (Platform.isIOS) ? 255 : 260;
              });

              // todo 5
              var currentLatLng = LatLng(currentPosition.latitude,currentPosition.longitude);
              var pickupLatLng = widget.tripDetails.pickup;

              //todo 6 (finish)
              await getDirection(currentLatLng, pickupLatLng);

            },
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 15,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  ),
                ]
              ),
              height: Platform.isIOS ? 283 : 255,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '14 Mins',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Brand-Bold',
                        color: BrandColors.colorAccentPurple,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Daniel Jones',style: TextStyle(fontSize: 22,fontFamily: 'Brand-Bold'),),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.phone),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Image.asset('images/pickicon.png', height: 16, width: 16),
                        SizedBox(width: 18),
                        Expanded(
                          child: Container(
                            child: Text(
                              'NYSD Rd,aaaa',
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Image.asset('images/desticon.png', height: 16, width: 16),
                        SizedBox(width: 18),
                        Expanded(
                          child: Container(
                            child: Text(
                              'NYSD Rd,aaaa',
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    TaxiButton(
                      title: 'ARRIVED',
                      color: BrandColors.colorGreen,
                      onPressed: (){},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getDirection(LatLng pickupLatLng, LatLng destinationLatLng) async{

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) => ProgressDialog(status: 'Please wait'),
    );

    var thisDetails = await HelperMethods.getDirectionDetails(pickupLatLng, destinationLatLng);

    Navigator.pop(context);

    print(thisDetails.encodePoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodePoints);

    polylineCoordinates.clear();

    if(results.isNotEmpty){
      // loop through all PointLatlng points and convert them
      // to a list of LatLng, required by the Polyline
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _polylines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyline);

    });

    // set bounds, make polyline to fit into the map
    LatLngBounds bounds;

    if(pickupLatLng.latitude > destinationLatLng.latitude && pickupLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    }else if(pickupLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(
        southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(
          destinationLatLng.latitude,
          pickupLatLng.longitude,
        ),
      );
    }else if(pickupLatLng.latitude > destinationLatLng.latitude){
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(
          pickupLatLng.latitude,
          destinationLatLng.longitude,
        ),
      );
    }else{
      bounds = LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }

    rideMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    // set marker
    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });

    // set circle
    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });

  }
}
