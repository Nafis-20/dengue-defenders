import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin_flutterflow.dart';
import 'package:vector_math/vector_math_64.dart';

class ARSpherePage extends StatefulWidget {
  @override
  _ARSpherePageState createState() => _ARSpherePageState();
}

class _ARSpherePageState extends State<ARSpherePage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AR Red Sphere"),
      ),
      body: ARView(
        onARViewCreated: _onARViewCreated,
      ),
    );
  }

  void _onARViewCreated(
      ARSessionManager sessionManager, ARObjectManager objectManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    // Initialize AR session
    arSessionManager.onInitialize(
      showFeature: true,
      handleTaps: true,
    );

    // Create and add a red sphere
    _addRedSphere();
  }

  void _addRedSphere() {
    // Create a 3D node for the red sphere
    final redSphereNode = ARNode(
      type: NodeType.local, // Local asset (not web-based)
      uri: 'assets/red_sphere.obj', // Add your red sphere model in assets
      position:
          Vector3(0, 0, -1), // Position the model 1 meter away from the user
      scale: Vector3(0.2, 0.2, 0.2), // Scale the sphere to a reasonable size
    );

    // Add the node to the AR scene
    arObjectManager.addNode(redSphereNode);
  }
}
