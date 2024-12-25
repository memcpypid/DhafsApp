import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dhafs_app/app/modules/profile/controllers/profile_controller.dart';

class EditProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image Section
              GestureDetector(
                onTap: () => _changeProfilePicture(context),
                child: Obx(() {
                  return CircleAvatar(
                    radius: 60,
                    backgroundImage: controller.profileImagePath.isNotEmpty
                        ? FileImage(File(controller.profileImagePath.value))
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _changeProfilePicture(context),
                child: const Text(
                  'Change Profile Picture',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Edit Fields
              _buildEditableField(
                label: "Name",
                value: controller.userName.value,
                onChanged: (value) {
                  controller.userName.value = value;
                },
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                label: "Email",
                value: controller.userEmail.value,
                onChanged: (value) {
                  controller.userEmail.value = value;
                },
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                label: "Phone Number",
                value: controller.userPhone.value,
                onChanged: (value) {
                  controller.userPhone.value = value;
                },
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                label: "Birth Date",
                value: controller.userBirthDate.value,
                onChanged: (value) {
                  controller.userBirthDate.value = value;
                },
              ),
              const SizedBox(height: 32),
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.updateProfileData();
                    Get.back(); // Close the edit profile screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build editable text fields
  Widget _buildEditableField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: TextEditingController(text: value),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  // Function to change profile picture
  void _changeProfilePicture(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
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
}
