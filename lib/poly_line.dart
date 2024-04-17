import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithPolyline extends StatefulWidget {
  @override
  _MapWithPolylineState createState() => _MapWithPolylineState();
}

class _MapWithPolylineState extends State<MapWithPolyline> {
  final Set<Polyline> _polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Polyline'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _addPolyline();
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default position
          zoom: 12,
        ),
        polylines: _polylines,
      ),
    );
  }

  void _addPolyline() {
    List<LatLng> polylineCoordinates = [
      const LatLng(37.7749, -122.4194),
      const LatLng(37.7896, -122.3892),
      const LatLng(37.7749, -122.3694),
    ];

    Polyline polyline = Polyline(
        polylineId: const PolylineId('polyline_id'),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
        jointType: JointType.mitered);

    setState(
      () {
        _polylines.add(polyline);
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapWithPolyline(),
  ));
}
