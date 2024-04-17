import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  final RxDouble latitude = RxDouble(0.0);
  final RxDouble longitude = RxDouble(0.0);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late GoogleMapController controller;

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    );
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    update();
  }

  Future<void> startSharingLocation() async {
    await getLocation();
    Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        await getLocation();
        await _firestore
            .collection(
                'active_order') // Replace 'users' with your collection name
            .doc('active_order')
            .set(
          {
            'driver_location':
                GeoPoint(latitude.value, longitude.value), // Use GeoPoint
          },
        );
      },
    );
  }

  Future<void> stopSharingLocation() async {}
}

class MyHomePageTracker extends StatelessWidget {
  const MyHomePageTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LocationController());
    final LocationController locationController =
        Get.find<LocationController>();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    _firestore
        .collection('active_order') // Replace 'users' with your collection name
        .doc('active_order')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        if (data['driver_location'] != null) {
          final GeoPoint geoPoint = data['driver_location'] as GeoPoint;
          locationController.latitude.value = geoPoint.latitude;
          locationController.longitude.value = geoPoint.longitude;
          locationController.update();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location Tracker'),
      ),
      body: GetBuilder<LocationController>(
        builder: (controller) => Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    controller.latitude.value, controller.longitude.value),
                zoom: 16.0,
              ),
              onMapCreated: (GoogleMapController mapController) {
                controller.controller = mapController;
              },
              markers: {
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: LatLng(
                      controller.latitude.value, controller.longitude.value),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.location.request(); // Request location permission
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: MyHomePageTracker(), // Replace with actual ID
    );
  }
}
