// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/strings.dart';
import '../../mark_icon.dart';
import '../../search.dart';
import '../../poly_line.dart';
import '../../multi_markers.dart';
import '../../marker.dart';
import '../../order_taxi.dart';
import '../../poly_lines.dart';
import '../../test.dart';
import '../home/home_screen_view.dart';
import '../trip_route/trip_route_view.dart';

class NavigatorBottomBarCnr extends GetxController {
  String title = homeTitle;
  final List<Widget> pages = [
    const TripRouteView(),
    GetCenterLocation(),
    PolylineExample(),
    // AddTaxiRequestPage(),
  ];
  int currentIndex = 0;
  void setCurrentIndex(int index) async {
    switch (index) {
      case 0:
        title = favoriteTitle;
      case 1:
        title = ordersTitle;
      case 2:
        title = homeTitle;
    }
    currentIndex = index;
    update();
  }
}
