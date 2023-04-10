import 'package:ar_flutter_plugin/models/ar_pose.dart';

class ARAugmentedImage {
  String name;
  int index;
  ARPose centerPose;
  TrackingMethod trackingMethod;
  double extentX;
  double extentZ;

  ARAugmentedImage.fromMap(Map<dynamic, dynamic> map)
      : this.name = map['name'],
        this.index = map['index'],
        this.extentX = map['extentX'],
        this.extentZ = map['extentZ'],
        this.centerPose = ARPose.fromMap(map['centerPose']),
        this.trackingMethod = TrackingMethod.values[map['trackingMethod']];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['index'] = this.index;
    data['extentX'] = this.extentX;
    data['extentZ'] = this.extentZ;
    data['centerPose'] = centerPose.toMap();
    data['trackingMethod'] = this.trackingMethod;

    return data;
  }
}

enum TrackingMethod {
  NOT_TRACKING,
  FULL_TRACKING,
  LAST_KNOWN_POSE,
}
