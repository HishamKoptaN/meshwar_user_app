import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaxiRequestPage extends StatefulWidget {
  @override
  _AddTaxiRequestPageState createState() => _AddTaxiRequestPageState();
}

class _AddTaxiRequestPageState extends State<AddTaxiRequestPage> {
  late GoogleMapController mapController;
  late LatLng currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طلب تاكسي'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              _getUserLocation();
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0444, 31.2357), // إحداثيات القاهرة
              zoom: 12,
            ),
            onTap: _selectLocation,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () => _addTaxiRequest(),
              child: const Text('إضافة طلب تاكسي'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getUserLocation() async {
    setState(() {
      currentLocation = const LatLng(30.0444, 31.2357);
    });
  }

  void _selectLocation(LatLng location) {
    setState(() {
      currentLocation = location;
    });
  }

  Future<void> _addTaxiRequest() async {
    await FirebaseFirestore.instance.collection('taxi_requests').add({
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude,
    }).then((value) {
      Get.snackbar(
        'تمت العملية بنجاح',
        'تم إضافة طلب التاكسي بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }).catchError(
      (error) {
        Get.snackbar(
          'خطأ',
          'حدثت مشكلة أثناء إضافة طلب التاكسي',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }
}
