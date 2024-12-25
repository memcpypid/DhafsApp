import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers
import 'package:dhafs_app/app/modules/controllers/auth_controllers.dart';
import 'package:dhafs_app/app/modules/login/views/login_view.dart';
import 'home_view.dart'; // Ganti dengan nama file home view Anda jika berbeda

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance

  @override
  void initState() {
    super.initState();
    _playMusic(); // Memutar musik saat splash screen
    _navigateToHome();
  }

  // Fungsi untuk memutar musik
  _playMusic() async {
    await _audioPlayer.play(
        AssetSource('sounds/sound2.wav')); // Memutar musik dari folder sounds
  }

  // Fungsi untuk menunggu beberapa detik dan berpindah ke halaman utama
  _navigateToHome() async {
    final AuthController _authController = Get.put(AuthController());
    await Future.delayed(
        Duration(seconds: 5)); // Splash screen ditampilkan selama 5 detik
    _authController.isLoggedIn.value
        ? Get.offAll(() => HomeView())
        : Get.offAll(
            () => LoginView()); // Pindah ke halaman HomeView setelah 5 detik
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose(); // Jangan lupa untuk dispose ketika tidak diperlukan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan logo atau gambar yang ingin Anda tampilkan
            Image.asset(
              'images/logo.jpg', // Pastikan Anda menambahkan gambar logo ke folder assets
              height: 300, // Atur tinggi sesuai keinginan
              width: 300, // Atur lebar sesuai keinginan
              fit: BoxFit
                  .contain, // Agar gambar tetap proporsional dan tidak terdistorsi
            ),
            SizedBox(height: 10),
            Text(
              "Welcome to Dhaf's Cakees", // Ganti dengan nama aplikasi Anda
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
