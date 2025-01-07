import 'dart:io';

import 'package:dhafs_app/app/modules/controllers/auth_controllers.dart';
import 'package:dhafs_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:dhafs_app/app/modules/profile/views/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final AuthController _authController = AuthController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  // onTap: () => _//changeProfilePicture(context),
                  child: Obx(() {
                    // Menampilkan gambar avatar yang diperbarui
                    if (controller.profileImagePath.isNotEmpty) {
                      return CircleAvatar(
                        backgroundImage:
                            FileImage(File(controller.profileImagePath.value)),
                        radius: 30,
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        radius: 30,
                        child: const Icon(Icons.person,
                            size: 30, color: Colors.white),
                      );
                    }
                  }),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.userRole.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Options
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildOption(
                    icon: Icons.person_outline,
                    title: "My Account",
                    subtitle: "Make changes to your account",
                    onTap: () {
                      Get.to(EditProfileView());
                    },
                  ),
                  _buildOption(
                    icon: Icons.logout,
                    title: "Log Out",
                    onTap: () {
                      _authController.logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function untuk mengubah foto profil
  void _changeProfilePicture(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text("Capture Photo"),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  controller.updateProfileImage(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  controller.updateProfileImage(image.path);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text("Foto"),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/image');
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text("Musik"),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/music');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 30),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
