import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DetailController extends GetxController {
  final _pickedImage = Rxn<File>();

  File? get pickedImage => _pickedImage.value;

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _pickedImage.value = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
