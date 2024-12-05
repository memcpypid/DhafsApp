import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/music_controller.dart';

class MusicPlayerView extends StatelessWidget {
  final MusicController controller = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // File Picker Button
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(type: FileType.audio);

                if (result != null) {
                  String filePath = result.files.single.path!;
                  controller.fileName.value = result.files.single.name;
                  await controller.playAudio(filePath);
                }
              },
              child: const Text("Pilih Musik"),
            ),

            const SizedBox(height: 20),

            // File Name
            Obx(() => Text(
                  controller.fileName.value.isEmpty
                      ? "Tidak Ada Musik yang Dipilih"
                      : "Diputar Sekarang: ${controller.fileName.value}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )),

            const SizedBox(height: 20),

            // Slider for Progress
            Obx(() => Slider(
                  value: controller.position.value.inSeconds.toDouble(),
                  max: controller.duration.value.inSeconds.toDouble(),
                  onChanged: (value) {
                    controller.seekAudio(Duration(seconds: value.toInt()));
                  },
                )),

            // Duration and Position
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDuration(controller.position.value),
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      formatDuration(controller.duration.value),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                )),

            const SizedBox(height: 20),

            // Control Buttons
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: controller.isPlaying.value
                          ? () => controller.stopAudio()
                          : null,
                    ),
                    IconButton(
                      icon: Icon(controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: () => controller.isPlaying.value
                          ? controller.pauseAudio()
                          : controller.resumeAudio(),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  // Format duration into mm:ss
  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
