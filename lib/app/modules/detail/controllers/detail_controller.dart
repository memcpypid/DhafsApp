import 'package:dhafs_app/app/data/models/models_cake.dart';
import 'package:dhafs_app/app/data/services/service_cake.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class DetailController extends GetxController {
  final _pickedImage = Rxn<File>();
  final DbController _dbController = DbController();
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  File? get pickedImage => _pickedImage.value;
  var image = ''.obs;
  var title = ''.obs;
  var deskripsiProduk = ''.obs;
  var hargaProduk = ''.obs;
  var keteranganProduk = ''.obs;
  var locationName = ''.obs;
  final Result result = Get.arguments as Result;
  var rolePembeli = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCake();
  }

  Future<void> fetchLocationName(String coordinate) async {
    try {
      final coordinates = coordinate.split(',');
      final latitude = double.parse(coordinates[0]);
      final longitude = double.parse(coordinates[1]);
      print(latitude);
      print(longitude);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        locationName.value =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        locationName.value = "Unknown Location";
      }
    } catch (e) {
      locationName.value = "Error fetching location";
      print("Error: $e");
    }
  }

  void fetchCake() async {
    rolePembeli.value = await _prefs.getString('user_role')! == 'Pembeli';
    await _dbController.getCakes();
    print('lokasi : ');
    print(result.location);
    await fetchLocationName(result.location);
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
        location: '',
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
