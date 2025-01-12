// import 'package:flutter/material.dart';
// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;

// class ARImageViewPage extends StatefulWidget {
//   @override
//   _ARImageViewPageState createState() => _ARImageViewPageState();
// }

// class _ARImageViewPageState extends State<ARImageViewPage> {
//   late ArCoreController arCoreController;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     arCoreController.dispose();
//   }

//   void _onArCoreViewCreated(ArCoreController controller) {
//     arCoreController = controller;
//     _addImageToAr();
//   }

//   // Method to add the image to the AR view
//   void _addImageToAr() async {
//     final node = ArCoreNode(
//       image: 'assets/logo.png', // Path to the image in your assets folder
//       position:
//           vector.Vector3(0, 0, -1), // Position it 1 meter away from the camera
//       scale: vector.Vector3(0.2, 0.2, 0.2), // Scale the image
//     );
//     arCoreController.addArCoreNodeWithAnchor(node);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("AR Image Display"),
//       ),
//       body: ArCoreView(
//         onArCoreViewCreated: _onArCoreViewCreated,
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: ARImageViewPage(),
//   ));
// }
