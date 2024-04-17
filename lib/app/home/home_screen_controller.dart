import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreenController extends GetxController {
  late GoogleMapController mapController;
  late LatLng currentLocation;
  Future<void> _getUserLocation() async {
    currentLocation = const LatLng(29.695100854122792, 31.24911076151989);
  }

  void _selectLocation(LatLng location) {
    currentLocation = location;
  }

  Future<void> addTaxiRequest() async {
    await FirebaseFirestore.instance.collection('taxi_requests').add({
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude,
      'user_name': 'user',
    }).then((value) {
      Get.snackbar(
        'تمت العملية بنجاح',
        'تم إضافة طلب التاكسي بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }).catchError(
      (error) {
        // إظهار رسالة خطأ في حالة حدوث خطأ أثناء الإضافة
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
