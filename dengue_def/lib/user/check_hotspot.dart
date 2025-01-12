import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Store markers for hotspots
  Set<Marker> _hotspotMarkers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchHotspotData();
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
      setState(() {});
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  Future<void> _fetchHotspotData() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('site_photo').get();

      final List<QueryDocumentSnapshot> documents = snapshot.docs;

      Set<Marker> markers = documents.map((doc) {
        final location = doc['location'] as Map<String, dynamic>;
        final double latitude = location['latitude'];
        final double longitude = location['longitude'];

        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: "Potential Breeding Site",
            snippet: "Lat: $latitude, Lng: $longitude",
          ),
        );
      }).toSet();

      setState(() {
        _hotspotMarkers = markers;
      });
    } catch (e) {
      debugPrint("Error fetching hotspot data: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Move camera to user's location when location is loaded
    if (_currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        ),
      );
    }
  }

  void _searchLocation(String query) async {
    // Placeholder for integrating Google Places API for location search
    debugPrint("Search query: $query");
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
                    target: LatLng(
                      _currentLocation!.latitude!,
                      _currentLocation!.longitude!,
                    ),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _hotspotMarkers, // Display the markers
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
