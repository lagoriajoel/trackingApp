import 'package:google_maps_flutter/google_maps_flutter.dart';

class Gimnasio {
  final int id;
  final String nombre;
  final LatLng position;

  Gimnasio({required this.id, required this.nombre, required this.position});

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id, nombre: $nombre, position: $position';
  }
}
