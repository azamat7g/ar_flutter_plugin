package io.carius.lars.ar_flutter_plugin.FlutterModels

import com.google.ar.core.Pose

class FlutterArCorePose(val translation: FloatArray, val rotation: FloatArray) {

    fun toHashMap(): HashMap<String, Any> {
        val map: HashMap<String, Any> = HashMap<String, Any>()
        map["translation"] = convertFloatArray(translation)
        map["rotation"] = convertFloatArray(rotation)
        return map
    }

    private fun convertFloatArray(array: FloatArray): DoubleArray {
        val doubleArray = DoubleArray(array.size)
        for ((i, a) in array.withIndex()) {
            doubleArray[i] = a.toDouble()
        }
        return doubleArray
    }
    
    companion object{
        fun fromPose(pose: Pose): FlutterArCorePose{
            return FlutterArCorePose(pose.translation, pose.rotationQuaternion)
        }
    }

}