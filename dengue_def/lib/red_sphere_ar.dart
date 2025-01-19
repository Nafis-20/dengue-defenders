// import 'package:flutter/material.dart';
// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;

// class RedSphereARPage extends StatefulWidget {
//   const RedSphereARPage({super.key});

//   @override
//   _RedSphereARPageState createState() => _RedSphereARPageState();
// }

// class _RedSphereARPageState extends State<RedSphereARPage> {
//   late ArCoreController _arCoreController;

//   @override
//   void dispose() {
//     _arCoreController.dispose();
//     super.dispose();
//   }

//   void _onArCoreViewCreated(ArCoreController controller) {
//     _arCoreController = controller;

//     // Add a red sphere to the AR scene
//     final material = ArCoreMaterial(color: Colors.red);
//     final sphere =
//         ArCoreSphere(materials: [material], radius: 0.1); // Radius in meters
//     final node = ArCoreNode(
//       shape: sphere,
//       position: vector.Vector3(0, 0, -1), // 1 meter in front of the camera
//     );

//     _arCoreController.addArCoreNode(node);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Red Sphere AR'),
//       ),
//       body: ArCoreView(
//         onArCoreViewCreated: _onArCoreViewCreated,
//         enableTapRecognizer: true,
//       ),
//     );
//   }
// }
