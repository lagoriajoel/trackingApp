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
  static const LatLng destinationPosition =
      LatLng(-46.447975778904144, -67.51982599155225);
  static const LatLng destinationPosition2 =
      LatLng(-46.445754503153175, -67.55101571365178);
  late final LatLng position;

  Location location = Location();
  init() async {
    LocationData currentLocation = await getCorrentLocation();
  }

  Future<LocationData> getCorrentLocation() async {
    var locationData = await location.getLocation();
    return locationData;
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
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
                  print(position);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrackingPage(
                              position1: position,
                              destinationPosition: destinationPosition)));
                },
                child: Text("Gimnasio 1")),
            ElevatedButton(
                onPressed: () {
                  print(position);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrackingPage(
                              position1: position,
                              destinationPosition: destinationPosition2)));
                },
                child: Text("Gimnasio 2")),
          ],
        ),
      ),
    );
  }
}
