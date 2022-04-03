import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_2_driver/globalvariabel.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  //todo 1 (dokumetasi google map)

  GoogleMapController mapController; //todo 2
  Completer<GoogleMapController> _controller = Completer(); //todo 3

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap( //todo 4 (finish)
          initialCameraPosition: googlePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
          },
        ),
      ],
    );
  }
}
