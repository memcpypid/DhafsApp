import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhafs_app/app/data/models/models_users.dart';
import 'package:dhafs_app/app/modules/login/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn.value = _prefs.containsKey('user_token');
  }

  Future<void> registerUser(String email, String password,
      Map<String, dynamic> additionalData) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _prefs.setString('user_token', _auth.currentUser!.uid);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({
        'email': email,
        ...additionalData,
      });
      Get.snackbar('Success', 'Registration successful',
          backgroundColor: Colors.green);
      Get.off(LoginView());
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: $error',
          backgroundColor: Colors.red);
      print(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;

      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user ID
      String userId = _auth.currentUser!.uid;

      // Fetch user data from Firestore
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Convert Firestore document to UserModel
        UserModel user = UserModel.fromJson(userDoc.data()!);

        // Optionally, save user data to local storage or state management
        _prefs.setString('user_token', userId);
        _prefs.setString('user_name', user.username);
        _prefs.setString('user_email', user.email);
        _prefs.setString('user_role', user.role);
        _prefs.setString('user_phone', user.phoneNumber);
        _prefs.setString('user_birthDate', user.birthDate);

        Get.snackbar('Success', 'Login berhasil',
            backgroundColor: Colors.green);
        isLoggedIn.value = true;
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', 'User data not found',
            backgroundColor: Colors.red);
      }
    } catch (error) {
      Get.snackbar('Error', 'Login gagal: $error', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _prefs.clear();
    isLoggedIn.value = false;
    _auth.signOut();
    Get.offAllNamed('/login');
  }
}
