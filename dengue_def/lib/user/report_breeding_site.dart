// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart' as path;

// class ReportBreedingSite extends StatefulWidget {
//   const ReportBreedingSite({super.key});

//   @override
//   _ReportBreedingSiteState createState() => _ReportBreedingSiteState();
// }

// class _ReportBreedingSiteState extends State<ReportBreedingSite> {
//   final ImagePicker _picker = ImagePicker();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _reasonController = TextEditingController();

//   File? _selectedImage;
//   String? _fileName;

//   Future<void> _openCamera() async {
//     final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
//     if (photo != null) {
//       setState(() {
//         _selectedImage = File(photo.path);
//         _fileName = path.basename(photo.path);
//       });
//     }
//   }

//   Future<void> _uploadFromGallery() async {
//     final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
//     if (photo != null) {
//       setState(() {
//         _selectedImage = File(photo.path);
//         _fileName = path.basename(photo.path);
//       });
//     }
//   }

//   Future<void> _uploadToFirestore() async {
//     if (_selectedImage == null ||
//         _locationController.text.isEmpty ||
//         _reasonController.text.isEmpty) {
//       _showErrorPopup("Please fill all fields and upload an image.");
//       return;
//     }

//     try {
//       // Ensure unique file names by appending a timestamp
//       String uniqueFileName =
//           '${DateTime.now().millisecondsSinceEpoch}_$_fileName';

//       // Upload the file to Firebase Storage
//       final storageRef =
//           FirebaseStorage.instance.ref().child('site_photos/$uniqueFileName');
//       await storageRef.putFile(_selectedImage!);

//       // Get the download URL and save it to Firestore
//       String downloadURL = await storageRef.getDownloadURL();
//       await FirebaseFirestore.instance.collection('site_photo').add({
//         'url': downloadURL,
//         'location': _locationController.text,
//         'reason': _reasonController.text,
//         'uploaded_at': DateTime.now(),
//       });

//       _showSuccessPopup();
//     } catch (e) {
//       debugPrint('Error uploading file: $e');
//       _showErrorPopup("Error uploading file: $e");
//     }
//   }

//   void _showSuccessPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Successful'),
//           content: const Text('The data has been uploaded successfully.'),
//           actions: [
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   _selectedImage = null;
//                   _fileName = null;
//                   _locationController.clear();
//                   _reasonController.clear();
//                 });
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showErrorPopup(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Report Breeding Site"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 "Upload Breeding Site Photo",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               _selectedImage != null
//                   ? Column(
//                       children: [
//                         Image.file(
//                           _selectedImage!,
//                           height: 200,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: _openCamera,
//                               icon: const Icon(Icons.camera_alt),
//                               label: const Text("Re-Capture"),
//                             ),
//                             ElevatedButton.icon(
//                               onPressed: _uploadFromGallery,
//                               icon: const Icon(Icons.photo_library),
//                               label: const Text("Re-Upload"),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   : Column(
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: _openCamera,
//                           icon: const Icon(Icons.camera_alt),
//                           label: const Text("Open Camera"),
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton.icon(
//                           onPressed: _uploadFromGallery,
//                           icon: const Icon(Icons.photo_library),
//                           label: const Text("Upload from Gallery"),
//                         ),
//                       ],
//                     ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _locationController,
//                 decoration: const InputDecoration(
//                   labelText: "Location of the Breeding Site",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _reasonController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   labelText:
//                       "Why do you think this place is a potential breeding site?",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _uploadToFirestore,
//                 icon: const Icon(Icons.cloud_upload),
//                 label: const Text("Submit"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportBreedingSite extends StatefulWidget {
  const ReportBreedingSite({super.key});

  @override
  _ReportBreedingSiteState createState() => _ReportBreedingSiteState();
}

class _ReportBreedingSiteState extends State<ReportBreedingSite> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  File? _selectedImage;
  String? _fileName;

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
        _fileName = path.basename(photo.path);
      });
    }
  }

  Future<void> _uploadFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
        _fileName = path.basename(photo.path);
      });
    }
  }

  Future<void> _saveToFirestore() async {
    if (_locationController.text.isEmpty || _reasonController.text.isEmpty) {
      _showErrorPopup("Please fill all fields.");
      return;
    }

    try {
      // Save location and reason only in Firestore
      await FirebaseFirestore.instance.collection('site_photo').add({
        'location': _locationController.text,
        'reason': _reasonController.text,
        'uploaded_at': DateTime.now(),
      });

      _showSuccessPopup();
    } catch (e) {
      debugPrint('Error saving data: $e');
      _showErrorPopup("Error saving data: $e");
    }
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Successful'),
          content: const Text('The data has been saved successfully.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedImage = null;
                  _fileName = null;
                  _locationController.clear();
                  _reasonController.clear();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Upload Breeding Site Photo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _selectedImage != null
                  ? Column(
                      children: [
                        Image.file(
                          _selectedImage!,
                          height: 200,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _openCamera,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text("Re-Capture"),
                            ),
                            ElevatedButton.icon(
                              onPressed: _uploadFromGallery,
                              icon: const Icon(Icons.photo_library),
                              label: const Text("Re-Upload"),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _openCamera,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Open Camera"),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _uploadFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text("Upload from Gallery"),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location of the Breeding Site",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText:
                      "Why do you think this place is a potential breeding site?",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveToFirestore,
                icon: const Icon(Icons.save),
                label: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
