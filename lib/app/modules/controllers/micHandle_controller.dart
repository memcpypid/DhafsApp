import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MichandleController extends GetxController {
  final TextEditingController _textController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    _initSpeech(); // Inisialisasi layanan pengenalan suara saat controllerdibuat
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
        _textController.text = result.recognizedWords;
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
}
