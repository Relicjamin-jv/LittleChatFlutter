
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class imageService{
  final ImagePicker picker = ImagePicker();

  Future getImage() async {
    File image;
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
    );
    image = File(pickedFile.path);
    return image;
  }
}