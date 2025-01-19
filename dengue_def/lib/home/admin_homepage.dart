import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile_page.dart';
import '../user/check_hotspot.dart';
import '../admin/verify_site.dart';
import '../user/breeding_site_details.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _verifiedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchVerifiedCount();
  }

  Future<void> _fetchVerifiedCount() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('site_photo')
          .where('status', isEqualTo: 'verified')
          .get();

      setState(() {
        _verifiedCount = querySnapshot.size;
      });
    } catch (e) {
      debugPrint('Error fetching verified count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Welcome Admin",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle, size: 32),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Text(
                "Manage community reports efficiently",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // Admin Tasks Section
              const Text(
                "Admin Tasks",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTaskCard(
                    context,
                    title: "Breeding Sites Pending",
                    count: 45,
                    color: Colors.orange,
                    icon: Icons.pending_actions,
                    onTap: () {
                      // Add navigation logic here if needed
                    },
                  ),
                  _buildTaskCard(
                    context,
                    title: "Verified Breeding Sites",
                    count: _verifiedCount,
                    color: Colors.green,
                    icon: Icons.verified,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BreedingSiteDetailsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Admin Actions Section
              const Text(
                "Admin Actions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _buildDutyButton(
                      context,
                      title: "Verify Breeding Sites",
                      icon: Icons.check_circle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VerifySitePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildDutyButton(
                      context,
                      title: "Check Breeding Sites",
                      icon: Icons.search,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckHotspotMapPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context,
      {required String title,
      required int count,
      required Color color,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(
              "$count listed",
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDutyButton(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
