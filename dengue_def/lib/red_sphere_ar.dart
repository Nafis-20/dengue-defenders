import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:flutter/material.dart';

class ARSpherePage extends StatefulWidget {
  @override
  _ARSpherePageState createState() => _ARSpherePageState();
}

class _ARSpherePageState extends State<ARSpherePage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Red Sphere'),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: addRedSphere,
              child: const Text('Add Red Sphere'),
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager sessionManager, ARObjectManager objectManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: null,
      showWorldOrigin: true,
    );

    arObjectManager.onInitialize();
  }

  Future<void> addRedSphere() async {
    final sphereNode = ARNode(
      shape: ARSphere(
        radius: 0.2, // Radius of the sphere (in meters)
        materials: [
          ARMaterial(
            color: Colors.red,
          ),
        ],
      ),
      position: Vector3(0.0, 0.0, -1.0), // Position in AR space
      rotation: Vector4(0.0, 0.0, 0.0, 0.0), // No rotation
    );

    bool didAddNode = await arObjectManager.addNode(sphereNode);
    if (didAddNode) {
      print('Red sphere added successfully!');
    } else {
      print('Failed to add red sphere.');
    }
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    arObjectManager.dispose();
    super.dispose();
  }
}
