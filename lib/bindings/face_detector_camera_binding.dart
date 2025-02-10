import 'package:face_detection_app/controllers/face_detector_camera_controller.dart';
import 'package:get/get.dart';

class FaceDetectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceDetectionController>(() => FaceDetectionController());
  }
}
