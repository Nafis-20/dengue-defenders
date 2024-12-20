import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class ReportBreedingSite extends StatefulWidget {
  const ReportBreedingSite({super.key});

  @override
  _ReportBreedingSiteState createState() => _ReportBreedingSiteState();
}

class _ReportBreedingSiteState extends State<ReportBreedingSite> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      File file = File(photo.path);
      String fileName = path.basename(photo.path);
      await _uploadToFirestore(file, fileName);
      _showSuccessPopup();
    }
  }

  Future<void> _uploadFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      File file = File(photo.path);
      String fileName = path.basename(photo.path);
      await _uploadToFirestore(file, fileName);
      _showSuccessPopup();
    }
  }

  Future<void> _uploadToFirestore(File file, String fileName) async {
    try {
      // Upload the file to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('breeding_photos/$fileName');
      await storageRef.putFile(file);

      // Get the download URL and save it to Firestore
      String downloadURL = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('breeding_photo').add({
        'url': downloadURL,
        'uploaded_at': DateTime.now(),
      });

      print('Photo uploaded successfully!');
    } catch (e) {
      debugPrint('Error uploading file: $e');
    }
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Successful'),
          content: const Text('The photo has been uploaded successfully.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Breeding Site"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _openCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Open the Camera"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _uploadFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text("Upload from Mobile"),
            ),
          ],
        ),
      ),
    );
  }
}
