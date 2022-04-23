import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_2_driver/brand_colors.dart';
import 'package:uber_clone_2_driver/datamodels/tripdetails.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';
import 'package:uber_clone_2_driver/widgets/taxi_button.dart';

class NewTripsPage extends StatefulWidget {

  final TripDetails tripDetails;
  NewTripsPage({this.tripDetails});

  @override
  _NewTripsPageState createState() => _NewTripsPageState();
}

//todo 1 (finish)

class _NewTripsPageState extends State<NewTripsPage> {

  GoogleMapController rideMapController;
  Completer<GoogleMapController> _controller = Completer();

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
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              rideMapController = controller;
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
}
