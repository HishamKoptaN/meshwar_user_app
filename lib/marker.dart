import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late LatLng geoPoint;

  @override
  void initState() {
    super.initState();
    fetchGeoPoint();
  }

  void fetchGeoPoint() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('active_order')
        .doc('active_order')
        .get();
    GeoPoint firestoreGeoPoint = document['location'];
    setState(
      () {
        geoPoint =
            LatLng(firestoreGeoPoint.latitude, firestoreGeoPoint.longitude);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: geoPoint,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('marker_id'),
            position: geoPoint,
            infoWindow: const InfoWindow(
              title: 'Your Location',
            ),
          ),
        },
      ),
    );
  }
}
