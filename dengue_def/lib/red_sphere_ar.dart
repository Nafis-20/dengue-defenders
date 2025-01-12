import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart'; // Ensure this is added for Vector3

class RedSphereARPage extends StatefulWidget {
  const RedSphereARPage({super.key});

  @override
  _RedSphereARPageState createState() => _RedSphereARPageState();
}

class _RedSphereARPageState extends State<RedSphereARPage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  @override
  void dispose() {
    arSessionManager.dispose();
    arObjectManager.dispose();
    super.dispose();
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: true,
    );

    arObjectManager.onInitialize();
    addRedSphere();
  }

  Future<void> addRedSphere() async {
    final node = ARNode(
      type: NodeType.sphere,
      materials: [
        ARMaterial(color: Colors.red),
      ],
      position: Vector3(0, 0, -1), // 1 meter in front
      scale: Vector3(0.1, 0.1, 0.1), // 10 cm sphere
    );

    bool? didAddNode = await arObjectManager.addNode(node);
    if (didAddNode == true) {
      print("Red sphere added successfully!");
    } else {
      print("Failed to add red sphere.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Sphere AR'),
      ),
      body: ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
      ),
    );
  }
}
