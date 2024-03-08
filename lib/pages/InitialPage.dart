import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tracking_app/pages/trackingPage.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  LocationData? correntLocation;
  static const LatLng destinationPosition =
      LatLng(-46.447975778904144, -67.51982599155225);
  LatLng? position;

  void getCorrentLocation() async {
    Location location = Location();

    correntLocation = await location.getLocation();
    location.getLocation().then(
      (value) {
        position = LatLng(value.latitude!, value.longitude!);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getCorrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrackingPage(
                              position1: position!,
                              destinationPosition: destinationPosition)));
                },
                child: Text("Gimnasio 1")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrackingPage(
                              position1: position!,
                              destinationPosition: destinationPosition)));
                },
                child: Text("Gimnasio 2")),
          ],
        ),
      ),
    );
  }
}
