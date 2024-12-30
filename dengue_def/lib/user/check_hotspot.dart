import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CheckHotspotMapPage extends StatefulWidget {
  const CheckHotspotMapPage({super.key});

  @override
  _CheckHotspotMapPageState createState() => _CheckHotspotMapPageState();
}

class _CheckHotspotMapPageState extends State<CheckHotspotMapPage> {
  late GoogleMapController _mapController;
  LocationData? _currentLocation;
  final Location _location = Location();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
      setState(() {});
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Move camera to user's location when location is loaded
    if (_currentLocation != null) {
      _mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      ));
    }
  }

  void _searchLocation(String query) async {
    // Integrate Google Places API here for location search
    print("Search query: $query");
    // Implementation to search location using Google Places API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotspot Map"),
      ),
      body: Stack(
        children: [
          _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: _searchLocation,
                  decoration: InputDecoration(
                    hintText: "Search for a location",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}