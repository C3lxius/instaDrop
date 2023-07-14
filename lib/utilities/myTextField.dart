// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:instadrop/utilities/constants.dart';

// ignore: camel_case_types
class myTextField extends StatelessWidget {
  const myTextField(
      {super.key,
      required this.userController,
      required this.hint,
      this.inputAction = TextInputAction.send,
      this.inputType = TextInputType.text,
      this.icon,
      this.isPass = false});

  final TextEditingController userController;
  final String hint;
  final bool isPass;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(
      context,
    ));
    return TextField(
      controller: userController,
      obscureText: isPass,
      textInputAction: inputAction,
      keyboardType: inputType,
      decoration: InputDecoration(
          prefixIcon: icon,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          isDense: true,
          filled: true,
          hintText: hint,
          hintStyle: const TextStyle(color: textColor)),
    );
  }
}
