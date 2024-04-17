import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineExample extends StatefulWidget {
  @override
  _PolylineExampleState createState() => _PolylineExampleState();
}

class _PolylineExampleState extends State<PolylineExample> {
  late GoogleMapController _controller;
  late List<LatLng> _polylineCoordinates;
  late Set<Polyline> _polylines;

  @override
  void initState() {
    super.initState();
    _polylineCoordinates = [
      const LatLng(37.7749, -122.4194),
      const LatLng(37.7854, -122.4024),
      const LatLng(37.7587, -122.4181),
      const LatLng(37.7590, -122.4294),
    ];
    _polylines = {
      Polyline(
          polylineId: const PolylineId('poly'),
          color: Colors.blue,
          points: _polylineCoordinates,
          width: 10,
          patterns: [
            PatternItem.dot,
            PatternItem.gap(10),
          ]),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polyline Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PolylineExample(),
  ));
}
