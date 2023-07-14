import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OtherMethods {
  Future<Uint8List> selectImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();

    XFile? image = await picker.pickImage(source: source);

    return image!.readAsBytes();
  }
}

showSnack({required String content, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
