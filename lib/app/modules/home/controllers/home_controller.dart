import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/services/service_cake.dart';
import '../../../data/models/models_cake.dart';

class HomeController extends GetxController {
  final DbController dbontroller = DbController();
  final TextEditingController textController = TextEditingController();
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  var rolePembeli = false.obs;

  var searchQuery = ''.obs; // Variabel untuk menyimpan kata kunci pencarian
  var filteredCakes = <Result>[].obs; // Daftar kue yang difilter

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    fetchCake();
  }

  Future<String> fetchLocationName(String coordinate) async {
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
        return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "Unknown Location";
      }
    } catch (e) {
      print("Error: $e");
      return "Menunggu Koneksi, Agar Mendapatkan Lokasi";
    }
  }

  void fetchCake() async {
    rolePembeli.value = await _prefs.getString('user_role')! == 'Pembeli';
    print(rolePembeli);
    await dbontroller.getCakes();
    filteredCakes.value = dbontroller.result; // Inisialisasi daftar filter
  }

  void CreateData(String url, String Title, String Harga, String Deskripsi,
      String Keterangan, String location) {
    final random = Random();
    final id = random.nextInt(1000000).toString(); // ID acak antara 0-999999
    Result newCake = Result(
        title: Title,
        image: url,
        id: id,
        imageType: ImageType.JPG,
        hargaProduk: Harga,
        deskripsiProduk: Deskripsi,
        keteranganProduk: Keterangan,
        location: location);
    dbontroller.addCake(newCake);
  }

  WebViewController webViewController(String uri) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(uri));
  }

  // Logika pencarian
  void filterCakes() {
    if (searchQuery.value.isEmpty) {
      filteredCakes.value = dbontroller.result;
    } else {
      filteredCakes.value = dbontroller.result
          .where((cake) => cake.title
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  // Instansiasi SpeechToText untuk menangani pengenalan suara
  final stt.SpeechToText _speech =
      stt.SpeechToText(); // Variabel observable untuk melacak status aplikasi
  var isListening =
      false.obs; // Menunjukkan apakah aplikasi sedangmendengarkan suara
  var text = "".obs; // Menyimpan teks yang dihasilkan dari pengenalan suara
  // Menginisialisasi fungsi pengenalan suara
  void _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      print(e);
    }
  }

  // Memeriksa dan meminta izin mikrofon
  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      // Jika izin belum diberikan, minta izin kepada pengguna
      await Permission.microphone.request();
    }
  }

  // Memulai mendengarkan suara dan memperbarui variabel teks dengan kata-katayang dikenali
  void startListening() async {
    await checkMicrophonePermission();
    if (await Permission.microphone.isGranted) {
      isListening.value = true;
      await _speech.listen(onResult: (result) {
        // Memperbarui kata-kata yang dikenali ke dalam variabel teks
        text.value = result.recognizedWords;
        textController.text = result.recognizedWords;
        searchQuery.value =
            result.recognizedWords; // Perbarui kata kunci pencarian
        filterCakes(); // Filter kue berdasarkan input suara
      });
    } else {
      print("Izin mikrofon ditolak.");
    }
  }

  // Menghentikan proses pengenalan suara
  void stopListening() async {
    isListening.value = false;
    await _speech.stop();
  }

  List<Result> get cakes => dbontroller.result;
  bool get isLoading => dbontroller.isLoading.value;
}
