import 'package:dhafs_app/app/modules/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final birthDateController = TextEditingController();

  var selectedRole = 'Penjual'.obs;
  final roles = ['Penjual', 'Pembeli'].obs;
  final AuthController _authController = Get.put(AuthController());
  Map<String, dynamic> getUserDataAsJson() {
    return {
      'username': usernameController.text,
      'phoneNumber': phoneNumberController.text,
      'birthDate': birthDateController.text,
      'role': selectedRole.value
    };
  }

  void Register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Information!', 'Please enter email and password!');
      return;
    }
    await _authController.registerUser(email, password, getUserDataAsJson());
  }

  bool getIsloading() {
    return _authController.isLoading.value;
  }
}
