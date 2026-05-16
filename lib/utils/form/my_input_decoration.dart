import 'package:flutter/material.dart';

import '../globals.dart';

//SETTING

InputDecoration myInputDecoration({
  String? suffix,

  // IconData? suffixIcon,
  String? hintText,
  String? helperText,
}) {
  return InputDecoration(
    filled: true,
    fillColor: bgTextFieldChat,
    hoverColor: Colors.transparent,
    helperText: helperText,
    suffix: suffix != null ? Text(suffix) : null,
    // suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: textFormError),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
    errorStyle: const TextStyle(color: textFormError),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
    disabledBorder: const OutlineInputBorder(),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: bgHeadSlider, width: 3),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
    hintText: hintText,
    hintStyle: const TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black54,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );
}
