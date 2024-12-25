import 'package:dhafs_app/app/modules/controllers/auth_controllers.dart';
import 'package:dhafs_app/app/modules/controllers/notification_handler.dart';
import 'package:dhafs_app/app/modules/home/views/splash_screen.dart';
import 'package:dhafs_app/app/modules/noConnection/views/noConnections_views.dart';
import 'package:dhafs_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';
import 'app/services/dependency_injection.dart';
import 'app/modules/noConnection/controllers/noConnection_controller.dart';

final AuthController _authController = Get.put(AuthController());
final NoconnectionController _noconnectionController =
    Get.put(NoconnectionController());
void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Get.putAsync(() async => await SharedPreferences.getInstance());
  await FirebaseMessagingHandler().initPushNotification();
  await FirebaseMessagingHandler().initLocalNotification();
  DependencyInjection.init();
  runApp(
    GetMaterialApp(
      title: "Application",
      home: SplashScreen(),
      // initialRoute:
      //     _authController.isLoggedIn.value ? Routes.HOME : Routes.LOGIN,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
