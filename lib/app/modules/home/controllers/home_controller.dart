import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/services/service_cake.dart';
import '../../../data/models/models_cake.dart';

class HomeController extends GetxController {
  final DbController dbontroller = DbController();
  final TextEditingController textController = TextEditingController();

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
      return "Error fetching location";
    }
  }

  void fetchCake() async {
    await dbontroller.getCakes();
  }

  void CreateData(String url, String Title, String Harga, String Deskripsi,
      String Keterangan, String location) {
    Result newCake = Result(
        title: Title,
        image: url,
        id: '',
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
