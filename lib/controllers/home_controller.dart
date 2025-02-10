import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_detection_app/controllers/face_detector_gallery_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';

class HomeController extends GetxController {
  RxBool isInitializedCamera = false.obs;
  late CameraController cameraController;
  FaceDetector? faceDetector;

  RxList<Face> detectedFaces = <Face>[].obs;
  var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: false),
  );

  @override
  Future<void> onInit() async {
    super.onInit();

    var cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);

    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          performanceMode: FaceDetectorMode.accurate,
          enableContours: true,
          enableLandmarks: true),
    );
  }

  
  Future<void> initializeCamera() async {
    await cameraController.initialize();
    isInitializedCamera.value = true;
    cameraController.setFlashMode(FlashMode.auto);
    captureAndDetectFace();
    cameraController.startImageStream((CameraImage image) {
      detectFaces(image);
    });

    update();
  }

  Future<void> detectFaces(CameraImage image) async {
    try {

      final InputImage inputImage = InputImage.fromBytes(
        bytes: image.planes[0].bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.yuv420,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final List<Face> faces = await faceDetector!.processImage(inputImage);

      detectedFaces.value = faces;
      logger.i("Detected ${faces.length} faces.");

      update();
    } catch (e) {
      logger.e("Face detection error: $e");
    }
  }

  Future<void> captureAndDetectFace() async {
    log('captureAndDetectFace() calling..');

    if (!cameraController.value.isInitialized) {
      logger.e("Camera not initialized");
      return;
    }

    try {
      log('try');
      XFile picture = await cameraController.takePicture();
      File imageFile = File(picture.path);
      log('capture image:$imageFile');

      final InputImage inputImage = InputImage.fromFile(imageFile);
      final List<Face> faces = await faceDetector!.processImage(inputImage);
      log('Faces:$faces');
      if (faces.isNotEmpty) {
        log('Not Empty');
        logger.i("Detected ${faces.length} faces.");
        for (Face face in faces) {
          final Rect boundingBox = face.boundingBox;
          logger.d("Face detected at: ${boundingBox.toString()}");
        }
      } else {
        log('no face');
        logger.w("No faces detected.");
      }
    } catch (e) {
      log('error');
      logger.e("Error capturing image: $e");
    }
  }

  // @override
  void onClose() {
    cameraController.dispose();
    faceDetector?.close();
    super.onClose();
  }
}
