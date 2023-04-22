import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecotaration(
      {required String hintText,
      required String labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange, width: 2)),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[800]),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.orange,
              )
            : null);
  }
}
