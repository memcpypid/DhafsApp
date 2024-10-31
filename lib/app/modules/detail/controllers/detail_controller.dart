import 'package:dhafs_app/app/data/models/models_cake.dart';
import 'package:dhafs_app/app/data/services/service_cake.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DetailController extends GetxController {
  final _pickedImage = Rxn<File>();
  final DbController _dbController = DbController();
  File? get pickedImage => _pickedImage.value;
  var image = ''.obs;
  var title = ''.obs;
  var deskripsiProduk = ''.obs;
  var hargaProduk = ''.obs;
  var keteranganProduk = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCake();
  }

  void fetchCake() async {
    await _dbController.getCakes();
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _pickedImage.value = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> updateData(String id) async {
    final updatedCake = Result(
        id: id,
        title: title.value,
        image: image.value,
        deskripsiProduk: deskripsiProduk.value,
        hargaProduk: hargaProduk.value,
        keteranganProduk: keteranganProduk.value,
        imageType: ImageType.JPG);

    await _dbController.updateCake(id, updatedCake);
    await _dbController.getCakes();
  }

  Future<void> DeleteData(String id) async {
    try {
      await _dbController.deleteCake(id);
      Get.snackbar('Success', 'Delete Data successful',
          backgroundColor: Colors.green);
      await _dbController.getCakes();
    } catch (e) {
      Get.snackbar('Error', 'Delete Error!', backgroundColor: Colors.red);
    }
  }
}
