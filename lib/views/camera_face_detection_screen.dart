import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:face_detection_app/utils/painter/camera_face_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceDetectionScreen extends StatefulWidget {
  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  bool isDetecting = false;
  List<Face> detectedFaces = [];
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0; // 0 for back, 1 for front

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        log("No cameras available.");
        return;
      }

      _startCamera(selectedCameraIndex);
    }
  }

  Future<void> _startCamera(int cameraIndex) async {
    _cameraController?.dispose();
    _cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) {
      setState(() {});
      _startFaceDetection();
    }
  }

  void _switchCamera() {
    selectedCameraIndex =
        (selectedCameraIndex == 0) ? 1 : 0; // Toggle between cameras
    _startCamera(selectedCameraIndex);
  }

  void _startFaceDetection() {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    _cameraController!.startImageStream((CameraImage image) async {
      if (isDetecting) return;
      isDetecting = true;

      try {
        final inputImage = _convertCameraImageToInputImage(image);
        if (inputImage == null) {
          isDetecting = false;
          return;
        }

        final faces = await _faceDetector.processImage(inputImage);

        if (mounted) {
          setState(() {
            detectedFaces = faces;
          });
        }
      } catch (e) {
        log("Face detection error: $e");
      } finally {
        isDetecting = false;
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
        rotation: _getRotation(cameras[selectedCameraIndex].sensorOrientation),
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
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Detection")),
      body: Stack(
        children: [
          _cameraController != null && _cameraController!.value.isInitialized
              ? CameraPreview(
                  _cameraController!,
                  child: CustomPaint(
                    painter: FacePainterr(detectedFaces),
                    child: Container(),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              "Faces Detected: ${detectedFaces.length}",
              style: GoogleFonts.metrophobic(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                height: 1.56,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _switchCamera,
              child: Icon(Icons.switch_camera),
            ),
          ),
        ],
      ),
    );
  }
}
