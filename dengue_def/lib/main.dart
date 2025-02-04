// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'auth/landing_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Dengue Defender',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const LandingPage(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UnityARScreen(),
    );
  }
}

class UnityARScreen extends StatefulWidget {
  @override
  _UnityARScreenState createState() => _UnityARScreenState();
}

class _UnityARScreenState extends State<UnityARScreen> {
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Unity AR in Flutter")),
      body: UnityWidget(
        onUnityCreated: (controller) {
          _unityWidgetController = controller;
        },
      ),
    );
  }
}
