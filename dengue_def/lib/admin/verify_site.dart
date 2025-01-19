import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VerifySitePage extends StatefulWidget {
  const VerifySitePage({super.key});

  @override
  _VerifySitePageState createState() => _VerifySitePageState();
}

class _VerifySitePageState extends State<VerifySitePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to mark a site as verified
  Future<void> _verifySite(String documentId) async {
    try {
      await _firestore
          .collection('site_photo')
          .doc(documentId)
          .update({'status': 'verified'});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reported site verified successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error verifying site: $e")),
      );
    }
  }

  // Function to delete a site report
  Future<void> _deleteSite(String documentId) async {
    try {
      await _firestore.collection('site_photo').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reported site removed successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting site: $e")),
      );
    }
  }

  // Function to navigate to the Google Map page
  void _openGoogleMap(double latitude, double longitude) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GoogleMapScreen(latitude: latitude, longitude: longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Reported Sites"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('site_photo').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No reported sites available."),
            );
          }

          final reports = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final location = report['location'];
              final reason = report['reason'];
              final status = report['status'];
              final documentId = report.id;
              final latitude = location['latitude'];
              final longitude = location['longitude'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location: Lat $latitude, Lng $longitude",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _openGoogleMap(latitude, longitude),
                        child: const Text("Open in Google Map"),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Reason: $reason",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Status: $status",
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _verifySite(documentId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Verify"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _deleteSite(documentId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Not Verify"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class GoogleMapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const GoogleMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("siteLocation"),
            position: LatLng(latitude, longitude),
          ),
        },
      ),
    );
  }
}
