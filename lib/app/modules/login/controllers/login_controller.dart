import 'package:dhafs_app/app/modules/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Information!', 'Please enter email and password.');
      return;
    }

    await _authController.loginUser(email, password);
  }

  bool getIsloading() {
    return _authController.isLoading.value;
  }
}
