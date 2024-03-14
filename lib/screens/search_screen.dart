import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tracking_app/model/gimnasio.dart';
import 'package:tracking_app/screens/maps_screen.dart';
import 'dart:math' as math;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  LatLng? startPosition = const LatLng(-46.447975778904144, -67.51982599155225);
  LatLng endPosition = const LatLng(-46.445754503153175, -67.55101571365178);
  LatLng? endPosition2 = const LatLng(-46.44197235116889, -67.51084916147663);
  List<Gimnasio> gimsList = [];
  Gimnasio gim1 = Gimnasio(
      id: 1,
      nombre: "Gimnasio Mosconi",
      position: const LatLng(-46.4422747914859, -67.5313492998305));
  Gimnasio gim2 = Gimnasio(
      id: 2,
      nombre: "Complejo Deportivo",
      position: const LatLng(-46.44197235116889, -67.51084916147663));
  late FocusNode startFocusNode;
  late FocusNode endFocusNode;

  Location location = Location();

  @override
  void initState() {
    getCorrentLocation();
    gimsList.add(gim1);
    gimsList.add(gim2);
    // getDistance(startPosition!.latitude, startPosition!.longitude,
    //     endPosition.latitude, endPosition.longitude);
    // TODO: implement initState
    super.initState();
  }

  //calcular la distancia entre ubicacion y destino
  double getDistance(lat1, lon1, lat2, lon2) {
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1);
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    var result = d * 1000;
    print(result.toString());
    return result; //in m
  }

  dynamic deg2rad(deg) {
    return deg * (math.pi / 180);
  }

  Future<LocationData> getCorrentLocation() async {
    var locationData = await location.getLocation();
    startPosition = LatLng(locationData.latitude!, locationData.longitude!);

    return locationData;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ListView.builder(
              itemCount: gimsList.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapScreen(
                                    startPosition: startPosition,
                                    endPosition: gimsList[index].position,
                                    distance: getDistance(
                                        startPosition!.latitude,
                                        startPosition!.longitude,
                                        gimsList[index].position.latitude,
                                        gimsList[index].position.longitude),
                                  )));
                    },
                    child: Text(gimsList[index].nombre));
              }),
        ),
      ),
    );
  }
}
