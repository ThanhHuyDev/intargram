import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput(
      {Key? key,
      required this.hintText,
      this.isPass = false,
      required this.textEditingController,
      required this.textInputType, required this.labelText})
      : super(key: key);

  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final String labelText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context,width: 1,color: Colors.grey),borderRadius: BorderRadius.circular(10));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          border: inputBorder,
          labelText: labelText,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(left: 15)),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}