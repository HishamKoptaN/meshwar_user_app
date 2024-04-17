import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapSearchScreen extends StatefulWidget {
  @override
  _MapSearchScreenState createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  late GoogleMapController mapController;
  late TextEditingController _searchController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void searchLocation(String searchText) async {
    List<Location> locations = await locationFromAddress(searchText);

    if (locations.isNotEmpty) {
      final LatLng searchedLocation =
          LatLng(locations.first.latitude, locations.first.longitude);

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: searchedLocation,
            zoom: 14.0,
          ),
        ),
      );

      setState(
        () {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('searched_location'),
              position: searchedLocation,
              infoWindow: const InfoWindow(
                title: 'Searched Location',
                snippet: 'This is the searched location',
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Search Example'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a location...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchLocation(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                searchLocation(value);
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(30.0444, 31.2357),
                zoom: 12.0,
              ),
              markers: _markers,
            ),
          ),
        ],
      ),
    );
  }
}
