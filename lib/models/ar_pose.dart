import 'package:vector_math/vector_math_64.dart';

class ARPose {
  late Vector3 translation;
  late Vector4 rotation;
  late Quaternion quaternionRotation;

  ARPose.fromMap(Map<dynamic, dynamic> map) {
    this.translation = Vector3.array(map["translation"]);
    this.rotation = Vector4.array(map["rotation"]);
    this.quaternionRotation = Quaternion.fromFloat64List(map["rotation"]);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['translation'] = this.translation.toString();
    data['quaternionRotation'] = this.quaternionRotation.toString();
    data['rotation'] = this.rotation.toString();

    return data;
  }
}
