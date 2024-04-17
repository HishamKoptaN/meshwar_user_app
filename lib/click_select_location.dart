import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationMap extends StatefulWidget {
  @override
  _SelectLocationMapState createState() => _SelectLocationMapState();
}

class _SelectLocationMapState extends State<SelectLocationMap> {
  LatLng selectedLocation =
      LatLng(29.694759217940586, 31.2487418577075); // الموقع الافتراضي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: selectedLocation,
          zoom: 14,
        ),
        onTap: (LatLng latLng) {
          setState(() {
            selectedLocation = latLng;
          });
        },
        markers: {
          Marker(
            markerId: MarkerId('selected_location'),
            position: selectedLocation,
            draggable: true,
            onDragEnd: (LatLng newPosition) {
              setState(() {
                selectedLocation = newPosition;
              });
            },
          ),
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SelectLocationMap(),
  ));
}
