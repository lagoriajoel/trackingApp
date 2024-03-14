import 'dart:async';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/constants/constants.dart';
import 'dart:ui' as ui;

List cars = [
  {'id': 0, 'name': 'Select a Ride', 'price': 0.0},
  {'id': 1, 'name': 'UberGo', 'price': 230.0},
];

class MapScreen extends StatefulWidget {
  final LatLng? startPosition;
  final LatLng? endPosition;
  final double? distance;

  const MapScreen(
      {Key? key, this.startPosition, this.endPosition, this.distance})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition _initialPosition;
  //final Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Uint8List? markerImage;

  List<String> images = ['assets/user.png', 'assets/markerPosition.png'];

  final List<Marker> _markers = <Marker>[];

  int selectedCarId = 1;
  bool backButtonVisible = true;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _initialPosition = CameraPosition(
      target: LatLng(
          widget.startPosition!.latitude, widget.startPosition!.longitude),
      zoom: 13.1,
    );
    loadData();
  }

  //imagen para el marcador

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadData() async {
    final Uint8List markerIcon =
        await getBytesFromAsset("assets/user.png", 100);
    _markers.add(Marker(
        markerId: const MarkerId("Ubicacion"),
        position: LatLng(
            widget.startPosition!.latitude, widget.startPosition!.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        infoWindow: const InfoWindow(title: 'Mi Ubicación')));
    final Uint8List markerIcon2 =
        await getBytesFromAsset("assets/marker3.png", 100);
    _markers.add(Marker(
        markerId: const MarkerId("Destino"),
        position:
            LatLng(widget.endPosition!.latitude, widget.endPosition!.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon2),
        infoWindow: const InfoWindow(title: 'Destino')));
    setState(() {});
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 3);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Google_api_kay,
        PointLatLng(
            widget.startPosition!.latitude, widget.startPosition!.longitude),
        PointLatLng(
            widget.endPosition!.latitude, widget.endPosition!.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: backButtonVisible
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              )
            : null,
      ),
      body: Stack(children: [
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            height: constraints.maxHeight / 2,
            child: GoogleMap(
              polylines: Set<Polyline>.of(polylines.values),
              mapType: MapType.hybrid,
              initialCameraPosition: _initialPosition,
              markers: Set.from(_markers),
              onMapCreated: (GoogleMapController controller) {
                Future.delayed(Duration(milliseconds: 1000), () {
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(_initialPosition));
                  _getPolyline();
                });
              },
            ),
          );
        }),
        DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 1,
            snapSizes: [0.5, 1],
            snap: true,
            builder: (BuildContext context, scrollSheetController) {
              return Container(
                  color: Colors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    controller: scrollSheetController,
                    itemCount: cars.length,
                    itemBuilder: (BuildContext context, int index) {
                      final car = cars[index];
                      if (index == 0) {
                        return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Divider(
                                    thickness: 5,
                                  ),
                                ),
                                Text(
                                    'Distancias hasta el lugar de disputa del encuentro')
                              ],
                            ));
                      }
                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          onTap: () {
                            setState(() {
                              selectedCarId = car['id'];
                            });
                          },
                          leading: Icon(Icons.car_rental),
                          title: Text('Distancia'),
                          trailing: Text(
                            widget.distance!.truncate().toString() + ' m',
                          ),
                          selected: selectedCarId == car['id'],
                          selectedTileColor: Colors.grey[200],
                        ),
                      );
                    },
                  ));
            }),
      ]),
    );
  }
}
