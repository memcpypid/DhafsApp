import 'package:dhafs_app/app/modules/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  void Register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Information!', 'Please enter email and password!');
      return;
    }
    await _authController.registerUser(email, password);
  }

  bool getIsloading() {
    return _authController.isLoading.value;
  }
}
