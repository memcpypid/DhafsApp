import 'package:dhafs_app/app/modules/controllers/auth_controllers.dart';
import 'package:dhafs_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';

final AuthController _authController = Get.put(AuthController());

void main() async {
  //final AuthController _authController = Get.put(AuthController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync(() async => await SharedPreferences.getInstance());
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute:
          _authController.isLoggedIn.value ? Routes.HOME : Routes.LOGIN,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
