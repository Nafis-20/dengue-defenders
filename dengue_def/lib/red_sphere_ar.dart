import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_updated/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_updated/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:ar_flutter_plugin_updated/widgets/ar_view.dart';

class ARPage extends StatefulWidget {
  @override
  _ARPageState createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;

  @override
  void dispose() {
    super.dispose();
    arSessionManager?.dispose();
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

    // Initialize AR session and object manager
    arSessionManager?.onInitialize(
      showFeature: true,
      handleTaps: true,
    );
    arObjectManager?.onInitialize();

    // Add a 3D model (a red sphere)
    _addRedSphere();
  }

  void _addRedSphere() {
    // Create a new AR node with a red sphere
    final sphereNode = ARNode(
      type:
          NodeType.webGL, // Specify the node type (WebGL for models from a URL)
      uri:
          'https://example.com/3dmodels/red_sphere.glb', // URL to your 3D model (can be local asset or a URL)
      position: Vector3(0, 0, -1), // Position the model in front of the user
      scale: Vector3(0.2, 0.2, 0.2), // Scale the model to a reasonable size
      rotation:
          Vector4(0, 0, 0, 0), // Optional: Set the rotation (Quaternion format)
    );

    // Add the node to the AR session
    arObjectManager?.addNode(sphereNode);
  }
}
