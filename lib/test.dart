import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetCenterLocation extends StatefulWidget {
  @override
  _GetCenterLocationState createState() => _GetCenterLocationState();
}

class _GetCenterLocationState extends State<GetCenterLocation> {
  late GoogleMapController _controller;
  LatLng _centerCoordinates = const LatLng(0, 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // Initial map center
          zoom: 12.0,
        ),
        markers: {
          Marker(
              markerId: const MarkerId('meeting_point_latitude'),
              position: _centerCoordinates,
              infoWindow: const InfoWindow(
                title: 'نقطة الالتقاء',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(1)),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCenterCoordinates,
        child: const Icon(Icons.location_searching),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _getCenterCoordinates() async {
    LatLngBounds bounds = await _controller.getVisibleRegion();
    LatLng center = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
    );
    setState(() {
      _centerCoordinates = center;
    });
    print('Center coordinates: $_centerCoordinates');
  }
}

void main() {
  runApp(MaterialApp(
    home: GetCenterLocation(),
  ));
}
