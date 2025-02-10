import 'package:camera/camera.dart';
import 'package:face_detection_app/views/camera_face_detection_screen.dart';
import 'package:face_detection_app/views/face_detector_gallery_view.dart';
import 'package:face_detection_app/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/face_auth.json'),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Face Recognization\n Authentication",
                        style: GoogleFonts.metrophobic(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.56,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                      style: GoogleFonts.metrophobic(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        height: 1.56,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CurvedElevatedButton(
                      text: "Capture Face",
                      onPressed: () {
                        Get.to(() => FaceDetectionScreen());
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CurvedElevatedButton(
                      text: "Detect With Gallery",
                      onPressed: () {
                        Get.to(() => const FaceDetectorGalleryView());
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
            /*   Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // controller.captureAndDetectFace();
                        // controller.initializeCamera();
                        Get.to(() => FaceDetectionScreen());
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
        */
          ],
        );
      }),
    );
  }
}
