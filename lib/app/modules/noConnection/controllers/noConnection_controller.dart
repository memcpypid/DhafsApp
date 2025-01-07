import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dhafs_app/app/data/models/models_cake.dart';
import 'package:dhafs_app/app/data/services/service_cake.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/views/home_view.dart';
import '../views/noConnections_views.dart';

class NoconnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final DbController dbontroller = DbController();
  bool isConnect = false;
  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      _updateConnectionStatus(connectivityResults.first);
    });
  }


  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    print(Get.currentRoute);
    if (connectivityResult == ConnectivityResult.none) {
      Get.offAll(() => const NoconnectionsViews());
      isConnect = false;
    } else {
      print(Get.currentRoute);
      isConnect = true;
      pushOfflineDataToFirestore();
      if (Get.currentRoute == '/NoconnectionsViews' ||
          Get.currentRoute == '/noconnection') {
        Get.offAll(() => HomeView());
      }
    }
  }

  Future<void> saveDataOffline(
    String title,
    String imageUrl,
    String desc,
    String harga,
    String keterangan,
    String coordinate,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final offlineData = prefs.getStringList('offlineData') ?? [];

    // Buat data baru
    final data = jsonEncode({
      'title': title,
      'image': imageUrl,
      'Deskripsi_Produk': desc,
      'harga_produk': harga,
      'Keterangan_Produk': keterangan,
      'location': coordinate,
    });
    offlineData.add(data);
    await prefs.setStringList('offlineData', offlineData);
    Get.snackbar('Informasi!', 'Data Berhasil Di Simpan Saat Offline!',
        backgroundColor: Colors.green);
  }

  Future<void> pushOfflineDataToFirestore() async {
    final prefs = await SharedPreferences.getInstance();
    final offlineData = prefs.getStringList('offlineData') ?? [];
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      for (var item in offlineData) {
        final data = jsonDecode(item);
        final random = Random();
        final id =
            random.nextInt(1000000).toString();
        Result newCake = Result(
          title: data['title'],
          image: data['image'],
          id: id,
          imageType: ImageType.JPG,
          hargaProduk: data['harga_produk'],
          deskripsiProduk: data['Deskripsi_Produk'],
          keteranganProduk: data['Keterangan_Produk'],
          location: data['location'],
        );
        dbontroller.addCake(newCake);
      }


      await prefs.remove('offlineData');
      if (!offlineData.isEmpty) {
        Get.snackbar('Informasi', 'Data Berhasil Di Tambahkan!',
            backgroundColor: Colors.green);
      }
    }
  }
}
