import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BreedingSiteDetailsPage extends StatelessWidget {
  const BreedingSiteDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breeding Site Details"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('site_photo')
            .where('status', isEqualTo: 'verified')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("No verified breeding sites found"));
          }

          final sites = snapshot.data!.docs;

          return ListView.builder(
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final site = sites[index];
              return Card(
                margin: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.bug_report,
                    color: Colors.lightBlue,
                    size: 40,
                  ),
                  title: Text(
                    "Site ID: ${site.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: ${site['status']}"),
                      if (site['location'] != null)
                        Text("Location: ${site['location']}"),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigate to a detailed page if required
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SiteDetailView(siteId: site.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SiteDetailView extends StatelessWidget {
  final String siteId;

  const SiteDetailView({required this.siteId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Site Details: $siteId"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('site_photo')
            .doc(siteId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading site details"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Site details not found"));
          }

          final siteData = snapshot.data!.data() as Map<String, dynamic>;

          final double? latitude = siteData['location']?['latitude'];
          final double? longitude = siteData['location']?['longitude'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Site ID: $siteId",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Status: ${siteData['status']}"),
                  if (latitude != null && longitude != null)
                    Text("Coordinates: ($latitude, $longitude)"),
                  if (siteData['reason'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text("Reason: ${siteData['reason']}"),
                    ),
                  if (siteData['description'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text("Description: ${siteData['description']}"),
                    ),
                  const SizedBox(height: 20),
                  if (latitude != null && longitude != null)
                    SizedBox(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(latitude, longitude),
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(siteId),
                            position: LatLng(latitude, longitude),
                            infoWindow: InfoWindow(
                              title: "Breeding Site",
                              snippet: "Verified site location",
                            ),
                          ),
                        },
                      ),
                    )
                  else
                    const Text(
                      "Location data not available for this site.",
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
