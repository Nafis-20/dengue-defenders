import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user/report_breeding_site.dart';
import '../user/play_snake_game.dart';
import '../user/play_tictactoe.dart';
import '../user/check_hotspot.dart';
import '../profile_page.dart';
import '../user/breeding_site_details.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  Future<int> _fetchVerifiedBreedingSites() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('site_photo')
          .where('status', isEqualTo: 'verified')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      debugPrint('Error fetching breeding sites: $e');
      return 0;
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
                    "Welcome",
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
                "Let's make your community safer today",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Defenders Tasks",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FutureBuilder<int>(
                    future: _fetchVerifiedBreedingSites(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildTaskCard(
                          context,
                          title: "Breeding Sites Identified",
                          count: 0,
                          color: Colors.lightBlue,
                          icon: Icons.bug_report,
                          onTap: () {},
                        );
                      } else if (snapshot.hasError) {
                        return _buildTaskCard(
                          context,
                          title: "Breeding Sites Identified",
                          count: 0,
                          color: Colors.lightBlue,
                          icon: Icons.bug_report,
                          onTap: () {},
                        );
                      }

                      return _buildTaskCard(
                        context,
                        title: "Breeding Sites Identified",
                        count: snapshot.data ?? 0,
                        color: Colors.lightBlue,
                        icon: Icons.bug_report,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BreedingSiteDetailsPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  _buildTaskCard(
                    context,
                    title: "Completed Missions",
                    count: 15,
                    color: Colors.purpleAccent,
                    icon: Icons.check_circle,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                "Today's Defender Duties",
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
                      title: "Report Breeding Sites",
                      icon: Icons.camera_alt,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReportBreedingSite(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildDutyButton(
                      context,
                      title: "Check Hotspot Map",
                      icon: Icons.map,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckHotspotMapPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildDutyButton(
                      context,
                      title: "Play the Snake-Ladder Game",
                      icon: Icons.games,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SnakeLadderGame(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildDutyButton(
                      context,
                      title: "Play the Tic-Tac-Toe Game",
                      icon: Icons.grid_on,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TicTacToeGame(),
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
