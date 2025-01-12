import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';

class RedSphereARPage extends StatefulWidget {
  const RedSphereARPage({super.key});

  @override
  _RedSphereARPageState createState() => _RedSphereARPageState();
}

class _RedSphereARPageState extends State<RedSphereARPage> {
  late ARSessionManager _arSessionManager;
  late ARObjectManager _arObjectManager;

  @override
  void dispose() {
    _arSessionManager.dispose();
    _arObjectManager.dispose();
    super.dispose();
  }

  void _onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
  ) {
    _arSessionManager = arSessionManager;
    _arObjectManager = arObjectManager;

    _arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: null,
      showWorldOrigin: true,
    );

    _arObjectManager.onInitialize();
    _addRedSphere();
  }

  Future<void> _addRedSphere() async {
    final node = ARNode(
      type: NodeType.sphere,
      materials: [
        ARMaterial(
          color: Colors.red,
        ),
      ],
      scale: Vector3(0.1, 0.1, 0.1), // Adjust scale
      position: Vector3(0.0, 0.0, -1.0), // Place 1 meter in front of the camera
    );

    bool? didAddNode = await _arObjectManager.addNode(node);
    if (didAddNode != null && didAddNode) {
      print('Red sphere added successfully!');
    } else {
      print('Failed to add red sphere.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Sphere AR'),
      ),
      body: ARView(
        onARViewCreated: _onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
      ),
    );
  }
}
