import 'dart:io';

import 'package:dhafs_app/app/modules/image/controllers/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ImageView extends StatelessWidget {
  final ImageController _cameraController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera & Gallery"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Section

            const SizedBox(height: 8),

            const SizedBox(height: 16),

            // Show Selected Image Section
            Obx(() {
              if (_cameraController.selectedImagePath.isEmpty) {
                return _buildPlaceholder("Tidak Ada Gambar",
                    icon: Icons.image_not_supported);
              } else {
                return _buildMediaCard(
                  "Gambar",
                  Image.file(
                    File(_cameraController.selectedImagePath.value),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              }
            }),
            const SizedBox(height: 16),

            // Show Selected Video Section
            Obx(() {
              if (_cameraController.selectedVideoPath.isEmpty) {
                return _buildPlaceholder("Tidak Ada VIdeo",
                    icon: Icons.videocam_off);
              } else {
                return _buildMediaCard(
                  "Video",
                  _cameraController.videoPlayerController != null &&
                          _cameraController
                              .videoPlayerController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _cameraController
                              .videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(
                              _cameraController.videoPlayerController!),
                        )
                      : const CircularProgressIndicator(),
                  actions: [
                    IconButton(
                      icon: Icon(
                        _cameraController.isVideoPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        _cameraController.togglePlayPause();
                      },
                    ),
                  ],
                );
              }
            }),
            const SizedBox(height: 16),

            // Buttons Section
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaCard(String title, Widget content,
      {List<Widget>? actions}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            content,
            if (actions != null) ...[
              const SizedBox(height: 8),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions)
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String message, {required IconData icon}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 64,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "Menu",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Ambil Foto"),
                  onPressed: () {
                    _cameraController.pickImage(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text("Pilih Foto"),
                  onPressed: () {
                    _cameraController.pickImage(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.videocam),
                  label: const Text("Ambil Video"),
                  onPressed: () {
                    _cameraController.pickVideo(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.video_library),
                  label: const Text("Pilih Video"),
                  onPressed: () {
                    _cameraController.pickVideo(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
