import 'package:flutter/material.dart';
import 'package:uber_clone_2_driver/datamodels/tripdetails.dart';

class NewTripsPage extends StatefulWidget {

  final TripDetails tripDetails;
  NewTripsPage({this.tripDetails});

  @override
  _NewTripsPageState createState() => _NewTripsPageState();
}

class _NewTripsPageState extends State<NewTripsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Trips'),
      ),
    );
  }
}
