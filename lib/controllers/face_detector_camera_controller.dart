import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceDetectionController extends GetxController {
  CameraController? cameraController;
  late FaceDetector faceDetector;
  RxBool isDetecting = false.obs;
  RxList<Face> detectedFaces = <Face>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    if (await Permission.camera.request().isGranted) {
      final cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();
      _startFaceDetection();
      update();
    }
  }

  void _startFaceDetection() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    cameraController!.startImageStream((CameraImage image) async {
      if (isDetecting.value) return;
      isDetecting.value = true;

      try {
        final inputImage = _convertCameraImageToInputImage(image);
        if (inputImage == null) {
          isDetecting.value = false;
          return;
        }

        final faces = await faceDetector.processImage(inputImage);
        detectedFaces.assignAll(faces);
      } catch (e) {
        log("Face detection error: $e");
      } finally {
        isDetecting.value = false;
      }
    });
  }

  InputImage? _convertCameraImageToInputImage(CameraImage image) {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (var plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();
      final Size imageSize =
          Size(image.width.toDouble(), image.height.toDouble());

      final InputImageMetadata metadata = InputImageMetadata(
        size: imageSize,
        rotation: _getRotation(cameraController!.description.sensorOrientation),
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      log("Error converting CameraImage: $e");
      return null;
    }
  }

  InputImageRotation _getRotation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      case 0:
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    faceDetector.close();
    super.onClose();
  }
}
