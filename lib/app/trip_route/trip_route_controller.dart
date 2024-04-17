import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class TripRouteController extends GetxController {
  late GoogleMapController mapController;
  late TextEditingController searchFromController;
  late TextEditingController searchDestinationController;
  LatLng meetingPointLatLng = const LatLng(0, 0);
  LatLng destinationPointLatLng = const LatLng(0, 0);
  bool selectLocationWidget = false;
  bool showPin = false;
  bool selectMeetingPoint = false;
  bool selectDestinationTrip = false;

  LatLng targetLocation = const LatLng(29.695632662706316, 31.248406581580642);
  LatLng currentLocation = const LatLng(29.695632662706316, 31.248406581580642);
  LatLng twoLocation = const LatLng(29.69157089079152, 31.24746646732092);
  String destinationText = '';

  final RxDouble currentPointLatitude = RxDouble(0.0);
  final RxDouble curentPointlongitude = RxDouble(0.0);

  final RxDouble meetingPointLatitude = RxDouble(0.0);
  final RxDouble meetingPointlongitude = RxDouble(0.0);

  final RxDouble destinationLatitude = RxDouble(0.0);
  final RxDouble destinationlongitude = RxDouble(0.0);

  final RxDouble driverlatitude = RxDouble(0.0);
  final RxDouble driverlongitude = RxDouble(0.0);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<LatLng> polylineCoordinates;
  late Set<Polyline> polylines;
  late BitmapDescriptor customMarker;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void onInit() {
    super.onInit();
    addCustomIcon();
    polylineCoordinates = [
      currentLocation,
      twoLocation,
    ];
    polylines = {
      Polyline(
        polylineId: const PolylineId('poly'),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 10,
        patterns: [
          PatternItem.dot,
          PatternItem.gap(10),
        ],
      ),
    };
    _firestore
        .collection('active_order') // Replace 'users' with your collection name
        .doc('active_order')
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.exists) {
          final Map<String, dynamic> data =
              snapshot.data() as Map<String, dynamic>;

          final GeoPoint meetingPointGeoPoint =
              data['meeting_location'] as GeoPoint;

          final GeoPoint destinationGeoPoint =
              data['destination_location'] as GeoPoint;

          final GeoPoint driverGeoPoint = data['driver_location'] as GeoPoint;

          meetingPointLatitude.value = meetingPointGeoPoint.latitude;
          meetingPointlongitude.value = meetingPointGeoPoint.longitude;

          destinationLatitude.value = destinationGeoPoint.latitude;
          destinationlongitude.value = destinationGeoPoint.longitude;

          driverlatitude.value = driverGeoPoint.latitude;
          driverlongitude.value = driverGeoPoint.longitude;
          update();
        }
      },
    );
    searchFromController = TextEditingController();
    searchDestinationController = TextEditingController();
    addPolyline();
  }

  void selectMeetingPointLocation(int number) {
    switch (number) {
      case 1:
        selectMeetingPoint = true;
        selectDestinationTrip = false;
        update();
      case 2:
        selectMeetingPoint = false;
        selectDestinationTrip = true;
        update();
    }
    print(number);
    hideSelectionLocation();
    enablePin();
  }

  void setPinLocation() async {
    LatLngBounds bounds = await mapController.getVisibleRegion();
    currentLocation = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
    );
    if (selectMeetingPoint) {
      meetingPointLatLng = currentLocation;
    } else if (selectDestinationTrip) {
      destinationPointLatLng = currentLocation;
    }
    showPin = false;
    update();
  }

  void showSelectionLocation() {
    selectLocationWidget = true;
    update();
  }

  void hideSelectionLocation() {
    selectLocationWidget = false;
    update();
  }

  void enablePin() {
    showPin = true;
    update();
  }

  void disablePin() {
    showPin = false;
    update();
  }

  void pinSelecttLocation(LatLng location) {
    meetingPointLatitude.value = location.latitude;
    meetingPointlongitude.value = location.longitude;
    disablePin();
    update();
  }

  void addCustomIcon() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/yellow.png")
        .then(
      (icon) {
        markerIcon = icon;
        update();
      },
    );
    update();
  }

  void setCurrentLocation(LatLng latLng) {
    currentLocation = latLng;
    print(currentLocation);
    update();
  }

//             Search Methods                         //
  Future<void> addMeetingPoint(LatLng latLng) async {
    GeoPoint geoPoint = GeoPoint(latLng.latitude, latLng.longitude);

    meetingPointLatitude.value = latLng.latitude;
    meetingPointlongitude.value = latLng.longitude;

    try {
      await FirebaseFirestore.instance
          .collection('active_order')
          .doc('active_order')
          .update(
        {'meeting_point': geoPoint},
      );
      print(latLng);
      update();
      print('Meeting point added to Firestore successfully!');
    } catch (e) {
      print('Error adding meeting point to Firestore: $e');
    }
  }

  void meetingPointSearch(String searchText) async {
    List<Location> location = await locationFromAddress(searchText);
    if (location.isNotEmpty) {
      double latitude = location.first.latitude;
      double longitude = location.first.longitude;
      GeoPoint geoPoint = GeoPoint(latitude, longitude);
      try {
        await FirebaseFirestore.instance
            .collection('active_order')
            .doc('active_order')
            .update(
          {
            'meeting_point': {
              'location': geoPoint,
              'description': searchText,
            }
          },
        );
        update();
        print('Meeting point added to Firestore successfully!');
      } catch (e) {
        print('Error adding meeting point to Firestore: $e');
      }
    }
  }

  Future<void> destinationSearch(String searchText) async {
    List<Location> location = await locationFromAddress(searchText);
    if (location.isNotEmpty) {
      GeoPoint geoPoint =
          GeoPoint(location.first.latitude, location.first.longitude);

      try {
        await FirebaseFirestore.instance
            .collection('active_order')
            .doc('active_order')
            .update(
          {
            'destination': {
              'location': geoPoint,
              'description': searchText,
            }
          },
        );
        update();
        print('Meeting point added to Firestore successfully!');
      } catch (e) {
        print('Error adding meeting point to Firestore: $e');
      }
    }
  }
  //             Search Methods                         //

  // Future<void> getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.best,
  //     forceAndroidLocationManager: true,
  //   );
  //   // latitude.value = position.latitude;
  //   // longitude.value = position.longitude;
  //   update();
  // }

  // Future<void> startSharingLocation() async {
  //   await getLocation();
  //   Timer.periodic(
  //     const Duration(seconds: 10),
  //     (timer) async {
  //       await getLocation();
  //       await _firestore.collection('active_order').doc('active_order').set(
  //         {
  //           // 'driver_location': GeoPoint(latitude.value, longitude.value),
  //         },
  //       );
  //     },
  //   );
  // }
  // Future<void> fetchGeoPoint() async {
  //   DocumentSnapshot document = await FirebaseFirestore.instance
  //       .collection('active_order')
  //       .doc('active_order')
  //       .get();
  //   GeoPoint meetingField = document['destination']['location'];
  //   GeoPoint destinationField = document['meeting_point']['location'];
  //   // GeoPoint driverField = document['driver_location'];
  //   geoPointMeeting = LatLng(meetingField.latitude, meetingField.longitude);
  //   geoPointDestination =
  //       LatLng(destinationField.latitude, destinationField.longitude);
  //   // geoPointDriver = LatLng(driverField.latitude, driverField.longitude);
  //   update();
  // }

  // Future<LatLng?> getGeoPoint() async {
  //   try {
  //     // احصل على الوثيقة من Firestore
  //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //         .collection('active_order')
  //         .doc('active_order')
  //         .get();
  //     GeoPoint? geoPoint = documentSnapshot.get('destination');
  //     if (geoPoint != null) {
  //       print(geoPoint);

  //       return LatLng(geoPoint.latitude, geoPoint.longitude);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching GeoPoint from Firestore: $e');
  //     return null;
  //   }
  // }
  Future<BitmapDescriptor> getCustomIcon() async {
    return SizedBox(
      height: 200,
      width: 200,
      child: Image.asset("temp image"),
    ).toBitmapDescriptor();
  }

  Future<void> addPolyline() async {
    List<LatLng> polylineCoordinates = [
      currentLocation,
      twoLocation,
    ];

    Polyline polyline = Polyline(
        polylineId: const PolylineId('polyline_id'),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
        jointType: JointType.mitered,
        patterns: [PatternItem.dot, PatternItem.gap(12)]);
    polylines.add(polyline);
    update();
  }
}

Future<BitmapDescriptor> getCustomIcon() async {
  return SizedBox(
    height: 200,
    width: 200,
    child: Image.asset('assets/yellow.png'),
  ).toBitmapDescriptor();
}

extension ToBitDescription on Widget {
  Future<BitmapDescriptor> toBitmapDescriptor(
      {Size? logicalSize,
      Size? imageSize,
      Duration waitToRender = const Duration(milliseconds: 300),
      TextDirection textDirection = TextDirection.ltr}) async {
    final widget = RepaintBoundary(
      child: MediaQuery(
          data: const MediaQueryData(),
          child: Directionality(textDirection: TextDirection.ltr, child: this)),
    );
    final pngBytes = await createImageFromWidget(widget,
        waitToRender: waitToRender,
        logicalSize: logicalSize,
        imageSize: imageSize);
    return BitmapDescriptor.fromBytes(pngBytes);
  }
}

Future<Uint8List> createImageFromWidget(Widget widget,
    {Size? logicalSize,
    required Duration waitToRender,
    Size? imageSize}) async {
  final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
  final view = ui.PlatformDispatcher.instance.views.first;
  logicalSize ??= view.physicalSize / view.devicePixelRatio;
  imageSize ??= view.physicalSize;
  // assert(logicalSize.aspectRatio == imageSize.aspectRatio);

  final RenderView renderView = RenderView(
    view: view,
    child: RenderPositionedBox(
        alignment: Alignment.center, child: repaintBoundary),
    configuration: ViewConfiguration(
      size: logicalSize,
      devicePixelRatio: 1.0,
    ),
  );
  final PipelineOwner pipelineOwner = PipelineOwner();
  final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();
  final RenderObjectToWidgetElement<RenderBox> rootElement =
      RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: widget,
  ).attachToRenderTree(buildOwner);

  buildOwner.buildScope(rootElement);

  await Future.delayed(waitToRender);

  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();

  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  final ui.Image image = await repaintBoundary.toImage(
      pixelRatio: imageSize.width / logicalSize.width);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}
