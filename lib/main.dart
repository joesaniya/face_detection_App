import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'utils/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Face Detection App",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
