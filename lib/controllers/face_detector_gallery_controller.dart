import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class FaceDetectorGalleryController extends GetxController {
  var logger = Logger();
  var selectedImagePath = ''.obs;
  var extractedBarcode = ''.obs;
  RxBool isLoading = false.obs;
  XFile? iimageFile;
  List<Face>? facess;
  ui.Image? iimage;
  Future<void> getImageAndDetectFaces() async {
    log('getImageAndDetectFaces gallery calling..');
    final imageFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));

    isLoading.value = true;

    final image = InputImage.fromFilePath(imageFile!.path);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          enableContours: true,
          enableLandmarks: true,
          performanceMode: FaceDetectorMode.fast),
    );
    /*GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
          performanceMode: FaceDetectorMode.fast, enableLandmarks: true));*/
    List<Face> faces = await faceDetector.processImage(image);
    iimageFile = imageFile;
    facess = faces;
    loadImage(imageFile);

    update();
  }

  Future<void> getImageAndDetectFacesCamera() async {
    log('getImageAndDetectFaces camera calling..');
    final imageFile =
        (await ImagePicker().pickImage(source: ImageSource.camera));

    isLoading.value = true;

    final image = InputImage.fromFilePath(imageFile!.path);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          enableContours: true,
          enableLandmarks: true,
          performanceMode: FaceDetectorMode.fast),
    );
    /*GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
          performanceMode: FaceDetectorMode.fast, enableLandmarks: true));*/
    List<Face> faces = await faceDetector.processImage(image);
    iimageFile = imageFile;
    facess = faces;
    loadImage(imageFile);

    update();
  }

  loadImage(XFile file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) => iimage = value);
    isLoading.value = false;

    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
