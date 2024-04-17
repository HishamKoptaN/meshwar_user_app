import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwar/helpers/media_query.dart';
import 'trip_route_controller.dart';

class TripRouteView extends StatelessWidget {
  const TripRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TripRouteController());
    return Scaffold(
      body: GetBuilder<TripRouteController>(
        init: TripRouteController(),
        builder: (cnr) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  cnr.mapController = controller;
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(29.694759217940586, 31.2487418577075),
                  zoom: 15.0,
                ),
                onTap: (LatLng latLng) async {
                  cnr.setCurrentLocation(latLng);
                },
                polylines: cnr.polylines,
                markers: {
                  Marker(
                      markerId: const MarkerId('meeting_point_latitude'),
                      position: cnr.meetingPointLatLng,
                      infoWindow: const InfoWindow(
                        title: 'نقطة الالتقاء',
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(1)),
                  Marker(
                      markerId: const MarkerId('destination'),
                      position: LatLng(cnr.destinationPointLatLng.latitude,
                          cnr.destinationPointLatLng.longitude),
                      // LatLng(cnr.destinationLatitude.value,
                      //     cnr.destinationlongitude.value),
                      infoWindow: const InfoWindow(
                        title: 'واجهة الرحله',
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(1)),
                  Marker(
                      markerId: const MarkerId('driver'),
                      position: LatLng(
                          cnr.driverlatitude.value, cnr.driverlongitude.value),
                      infoWindow: const InfoWindow(
                        title: 'السائق',
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(1)),
                },
              ),
              Positioned(
                right: context.screenWidth * 5,
                top: context.screenHeight * 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    color: Colors.blue,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      cnr.selectLocationWidget
                          ? cnr.hideSelectionLocation()
                          : cnr.showSelectionLocation();
                    },
                    child: Row(
                      children: [
                        cnr.selectLocationWidget
                            ? const Icon(Icons.arrow_downward_sharp)
                            : const Icon(Icons.add),
                        const Text(
                          'حدد الموقع ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              cnr.selectLocationWidget
                  ? Positioned(
                      right: context.screenWidth * 5,
                      top: context.screenHeight * 7,
                      child: Container(
                        width: context.screenWidth * 90,
                        height: context.screenHeight * 25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  cnr.selectMeetingPointLocation(1);
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText:
                                            'موقعك الحالي او اضغط لاختيار موقع اخر',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                              Icons.add_location_alt,
                                              size: 35,
                                              color: Colors.black),
                                          //  cnr.selectMeetingPoint
                                          //     ? const Icon(Icons.check,
                                          //         size: 35, color: Colors.black)
                                          //     : const Icon(
                                          //         Icons.add_location_alt,
                                          //         size: 35,
                                          //         color: Colors.black),
                                          onPressed: () async {
                                            // cnr.showPin
                                            //     ? cnr.pinSelecttLocation
                                            //     : null;
                                          },
                                        ),
                                        enabled: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  cnr.selectMeetingPointLocation(2);
                                },
                                child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      enabled: false,
                                      controller:
                                          cnr.searchDestinationController,
                                      decoration: InputDecoration(
                                        hintText: 'اضغط لاختيار واجة الرحله ',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                              Icons.add_location_alt,
                                              size: 35,
                                              color: Colors.black),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              cnr.showPin
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const Spacer(),
                          const Icon(
                            Icons.pin_drop,
                            size: 50,
                            color: Colors.red,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              cnr.setPinLocation();
                            },
                            child: Container(
                              width: context.screenWidth * 30,
                              height: context.screenHeight * 7,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.blue),
                              child: const Center(
                                child: Text(
                                  'تأكيد',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
