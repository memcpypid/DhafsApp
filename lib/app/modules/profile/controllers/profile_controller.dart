// import 'package:dhafs_app/app/data/models/models_cake.dart';
// import 'package:dhafs_app/app/data/services/service_cake.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

class ProfileController extends GetxController {
  // Observable variable
  var userName = "Darma Putra".obs;
  var profileImagePath = "".obs;

  void updateProfileImage(String path) {
    profileImagePath.value = path;
  }
}
