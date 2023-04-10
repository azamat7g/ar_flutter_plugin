import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_augmented_image.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:vector_math/vector_math_64.dart';

class AugmentedImagesWidget extends StatefulWidget {
  const AugmentedImagesWidget({Key? key}) : super(key: key);

  @override
  _AugmentedImagesWidgetState createState() => _AugmentedImagesWidgetState();
}

class _AugmentedImagesWidgetState extends State<AugmentedImagesWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AugmentedImages'),
        ),
        body: Container(
            child: Stack(children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
        ])));
  }

  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager) async {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: false,
          showWorldOrigin: false,
        );

    // this.arObjectManager!.onInitialize();

    arSessionManager.onTrackingImage = _handleOnTrackingImage;

    final ByteData bytes = await rootBundle.load('assets/myimages.imgdb');
    arSessionManager.loadAugmentedImagesDatabase(bytes: bytes.buffer.asUint8List());
  }

  _handleOnTrackingImage(ARAugmentedImage augmentedImage) async {
    Logger().wtf(augmentedImage.toMap());

    var newAnchor = ARPlaneAnchor(
      transformation: Matrix4.compose(
        augmentedImage.centerPose.translation,
        augmentedImage.centerPose.quaternionRotation,
        Vector3(0.1, 0.1, 0.1),
      ),
    );

    bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
    if (didAddAnchor != null && didAddAnchor) {
      var newNode = ARNode(
        type: NodeType.localGLTF2,
        uri: "Models/Chicken_01/Chicken_01.gltf",
        scale: Vector3(0.1, 0.1, 0.1),
        position: Vector3.zero(),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );

      bool? didAddLocalNode = await this.arObjectManager!.addNode(newNode, planeAnchor: newAnchor);

      var newNode2 = ARNode(
        type: NodeType.localGLTF2,
        uri: "Models/AnimatedMorphSphere/AnimatedMorphSphere.gltf",
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0, 0, 0.5),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );

      bool? didAddLocalNode2 = await this.arObjectManager!.addNode(newNode2, planeAnchor: newAnchor);
    }
  }
}
