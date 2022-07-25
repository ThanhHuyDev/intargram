import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
export 'package:intargram/untils/colors.dart';
export 'package:intargram/untils/dimens.dart';

pickImage(ImageSource source) async {
  ImagePicker? picker = ImagePicker();
  XFile? file = await picker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  // ignore: avoid_print
  print('no image selected');
}

showSnackbar(String title, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title),padding: const EdgeInsets.only(left: 30),));
}
