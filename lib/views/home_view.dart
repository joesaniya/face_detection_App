import 'package:camera/camera.dart';
import 'package:face_detection_app/views/face_detector_gallery_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection App'),
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(builder: (context) {
        return Stack(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: controller.isInitializedCamera == true
                  ? CameraPreview(controller.cameraController)
                  : null,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        controller.initializeCamera();
                       
                      },
                      child: const Text("Capture Face")),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => const FaceDetectorGalleryView());
                      },
                      child: const Text("Detect with Gallery")),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
