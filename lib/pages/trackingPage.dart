import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tracking_app/constants/constants.dart';

// ignore: must_be_immutable
class TrackingPage extends StatefulWidget {
  LatLng position1;
  LatLng destinationPosition;
  TrackingPage(
      {required this.position1, required this.destinationPosition, super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  // static const LatLng _destinationPosition =
  //     LatLng(-46.447975778904144, -67.51982599155225);

  List<LatLng> polylineCordinates = [];
  LocationData? correntLocation;

  void getCorrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) => correntLocation = location);
    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      correntLocation = newLoc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 14.5,
              target: LatLng(newLoc.latitude!, newLoc.longitude!))));

      setState(() {});
    });
  }

  void getPolylinesPoint(LatLng position, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Google_api_kay,
        PointLatLng(position.latitude, position.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCordinates.add(LatLng(point.latitude, point.longitude)));

      setState(() {});
    }
  }

  @override
  void initState() {
    getCorrentLocation();

    getPolylinesPoint(widget.position1, widget.destinationPosition);

    //setMarkerIcons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tracking App",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: correntLocation == null
          ? const Center(child: Text("Loading..."))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      correntLocation!.latitude!, correntLocation!.longitude!),
                  zoom: 10.1),
              mapType: MapType.terrain,
              polylines: {
                Polyline(
                    polylineId: const PolylineId("Route"),
                    points: polylineCordinates,
                    color: Colors.blueAccent,
                    width: 6)
              },
              markers: {
                Marker(
                    markerId: const MarkerId("correntLocation"),
                    infoWindow: InfoWindow(
                        title: "Corrent Location",
                        snippet: "correntLocation..."),
                    position: widget.position1),
                Marker(
                    markerId: MarkerId("initialLocation"),
                    position: LatLng(correntLocation!.latitude!,
                        correntLocation!.longitude!)),
                Marker(
                    markerId: MarkerId("Destination"),
                    position: widget.destinationPosition)
              },
              onMapCreated: (controller) => {_controller.complete(controller)},
            ),
    );
  }
}
