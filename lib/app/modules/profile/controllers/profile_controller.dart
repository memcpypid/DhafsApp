// import 'package:dhafs_app/app/data/models/models_cake.dart';
// import 'package:dhafs_app/app/data/services/service_cake.dart';
// import 'package:flutter/material.dart';
// import 'package:dhafs_app/main.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
import 'package:dhafs_app/app/data/models/models_users.dart';

class ProfileController extends GetxController {
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  var userId = "".obs;
  var userName = "".obs;
  var userEmail = "".obs;
  var userRole = "".obs;
  var userPhone = "".obs;
  var userBirthDate = "".obs;
  var profileImagePath = "".obs;
  @override
  void onInit() {
    super.onInit();
    getUserData();
    getProfileImage();
    fetchUserDataFromFirestore();
  }

  Future<void> fetchUserDataFromFirestore() async {
    try {
      String uid =
          userId.value; // Mendapatkan UID pengguna dari SharedPreferences
      if (uid.isEmpty) {
        print("User ID not found.");
        return;
      }

      // Mengambil data pengguna dari Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();

        // Perbarui data pengguna di controller
        if (data != null) {
          userName.value = data['username'] ?? '';
          userEmail.value = data['email'] ?? '';
          userRole.value = data['role'] ?? '';
          userPhone.value = data['phoneNumber'] ?? '';
          userBirthDate.value = data['birthDate'] ?? '';
          profileImagePath.value = data['profileImage'] ?? '';

          // Simpan ke SharedPreferences untuk caching
          _prefs.setString('user_name', userName.value);
          _prefs.setString('user_email', userEmail.value);
          _prefs.setString('user_role', userRole.value);
          _prefs.setString('user_phone', userPhone.value);
          _prefs.setString('user_birthDate', userBirthDate.value);
          _prefs.setString('profile_image_path', profileImagePath.value);

          print("User data fetched successfully.");
        }
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

// Fungsi untuk menampilkan gambar profil
  Widget displayProfileImage() {
    if (profileImagePath.value.isNotEmpty) {
      return Image.file(File(profileImagePath.value));
    } else {
      return Icon(Icons.account_circle, size: 100); // Gambar default
    }
  }

  void updateProfileImage(String path) {
    profileImagePath.value = path;
    _prefs.setString('profile_image_path', path); // Update SharedPreferences
  }

  // Fungsi untuk memilih gambar dan menyimpannya di local storage
  Future<void> pickAndSaveProfileImage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String path =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Menyimpan gambar ke file sistem lokal
        final File file = File(pickedFile.path);
        await file.copy(path);

        // Menyimpan path gambar di SharedPreferences
        await _prefs.setString('profile_image_path', path);

        // Update path di controller
        profileImagePath.value = path;

        print('Image saved to: $path');
      }
    } catch (e) {
      print('Error picking and saving image: $e');
    }
  }

  Future<void> getProfileImage() async {
    String? savedPath = _prefs.getString('profile_image_path');
    if (savedPath != null) {
      profileImagePath.value = savedPath;
      print('Profile image path: $savedPath');
    }
  }

  Future<void> getUserData() async {
    userId.value = _prefs.getString('user_token')!;
    userName.value = _prefs.getString('user_name')!;
    userEmail.value = _prefs.getString('user_email')!;
    userRole.value = _prefs.getString('user_role')!;
    userPhone.value = _prefs.getString('user_phone')!;
    userBirthDate.value = _prefs.getString('user_birthDate')!;
    if (userId != null &&
        userName != null &&
        userEmail != null &&
        userRole != null &&
        userPhone != null &&
        userBirthDate != null) {
      print('User ID: $userId');
      print('User Name: $userName');
      print('User Email: $userEmail');
      print('User Role: $userRole');
      print('User Phone: $userPhone');
      print('User Birth Date: $userBirthDate');
    } else {
      print('User data not found.');
    }
  }

  // void saveUserData() {
  //   _prefs.setString('user_name', userName.value);
  //   _prefs.setString('user_email', userEmail.value);
  //   _prefs.setString('user_phone', userPhone.value);
  //   _prefs.setString('user_birthDate', userBirthDate.value);
  //   _prefs.setString('user_token', userId.value); // Jika perlu menyimpan userId

  //   // Jika ingin menyimpan gambar ke storage atau server, lakukan di sini
  //   if (profileImagePath.isNotEmpty) {
  //     // Simpan gambar ke server atau storage
  //   }
  //   print('User data saved');
  // }

// Fungsi untuk menyimpan atau memperbarui data profil pengguna
  Future<void> updateProfileData() async {
    try {
      String uid = userId.value; // Mendapatkan UID pengguna yang sedang login
      print(uid);
      Map<String, dynamic> profileData = {
        'birthDate': userBirthDate.value,
        'username': userName.value,
        'email': userEmail.value,
        'phoneNumber': userPhone.value,
        'profileImage': profileImagePath.value,
        'role': userRole.value
      };

      // Melakukan update data pada dokumen pengguna di Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(profileData);

      print("Profile updated successfully.");
      await Get.snackbar("Informasi!", 'Update Profile Berhasil!');
      await fetchUserDataFromFirestore();
      await getUserData();
      await getProfileImage();
    } catch (e) {
      print("Error updating profile: $e");
    }
  }
}
