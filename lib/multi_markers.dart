import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithMarkers extends StatefulWidget {
  @override
  _MapWithMarkersState createState() => _MapWithMarkersState();
}

class _MapWithMarkersState extends State<MapWithMarkers> {
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Markers'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _addMarkers();
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default position
          zoom: 12,
        ),
        markers: _markers,
      ),
    );
  }

  void _addMarkers() {
    // Define marker locations
    List<Marker> markers = [
      const Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(37.7749, -122.4194), // Marker 1 position
        infoWindow: InfoWindow(title: 'Marker 1'), // Optional: Info window
        //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Optional: Custom icon
      ),
      const Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(37.7896, -122.3892), // Marker 2 position
        infoWindow: InfoWindow(title: 'Marker 2'), // Optional: Info window
        //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Optional: Custom icon
      ),
      const Marker(
        markerId: MarkerId('marker_3'),
        position: LatLng(37.7749, -122.3694),
        infoWindow: InfoWindow(title: 'Marker 3'),
      ),
    ];

    setState(() {
      _markers.addAll(markers);
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: MapWithMarkers(),
  ));
}
