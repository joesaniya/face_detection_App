import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';

class HomeController extends GetxController {
  RxBool isInitializedCamera = false.obs;
  //RxBool isInitializedCamera=false.obs;
  FaceDetector? faceDetector;
  late CameraController cameraController;

  var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: false),
  );
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    var cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);

    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          performanceMode: FaceDetectorMode.accurate,
          enableContours: true,
          enableLandmarks: true),
    );

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

  Future getAvailableCamera() async {
    final cameras = await availableCameras();
    return cameras;
  }

  initializeCamera() async {
    await cameraController.initialize();
    isInitializedCamera.value = true;
    cameraController.setFlashMode(FlashMode.always);

    update();
  }
}
