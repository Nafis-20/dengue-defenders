// File: lib/user/report_breeding_site.dart
import 'package:flutter/material.dart';

class ReportBreedingSite extends StatelessWidget {
  const ReportBreedingSite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Breeding Site"),
      ),
      body: Center(
        child: const Text(
          "This is the Report Breeding Site page.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
