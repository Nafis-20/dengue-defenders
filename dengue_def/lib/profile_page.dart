import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String? _imageUrl;
  String? _email;
  String? _role;
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['name'];
          _email = userDoc['email'];
          _role = userDoc['role'];
          _imageUrl = userDoc.data().toString().contains('profileImage')
              ? userDoc['profileImage']
              : null;
          _points = userDoc.data().toString().contains('points')
              ? userDoc['points']
              : 0;
        });
      }
    }
  }

  Future<void> _updateName() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': _nameController.text});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name updated successfully")),
      );
    }
  }

  Future<void> _uploadProfileImage() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final Reference storageRef =
          _storage.ref().child('profile_pictures/${user.uid}.jpg');

      await storageRef.putFile(file);

      final String downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImage': downloadUrl});

      setState(() {
        _imageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture updated successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                  backgroundColor: Colors.grey[200],
                  child: _imageUrl == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
                IconButton(
                  onPressed: _uploadProfileImage,
                  icon: const Icon(Icons.camera_alt, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Points: $_points',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(height: 30),
            ListTile(
              title: const Text('Name'),
              subtitle: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Enter your name",
                ),
                onSubmitted: (_) => _updateName(),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: _updateName,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(
                _email ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Role'),
              subtitle: Text(
                _role ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
