import 'package:face_detection_app/bindings/face_detector_camera_binding.dart';
import 'package:face_detection_app/views/camera_face_detection_screen.dart';
import 'package:get/get.dart';

import '../../bindings/face_detector_gallery_binding.dart';
import '../../views/face_detector_gallery_view.dart';
import '../../bindings/home_binding.dart';
import '../../views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FACE_DETECTOR_GALLERY,
      page: () => const FaceDetectorGalleryView(),
      binding: FaceDetectorGalleryBinding(),
    ),
    /* GetPage(
      name: _Paths.FACE_DETECTOR_GALLERY,
      page: () => FaceDetectionScreen(),
      binding: FaceDetectionBinding(),
    ),*/
  ];
}
