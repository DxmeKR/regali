import 'package:flutter/material.dart';

import '../globals.dart';

//UTIL

InputDecoration myInputDecoration({
  String? suffix,
  // IconData? suffixIcon,
  bool isRectangular = true,
  String? hintText,
  String? helperText,
}) {
  if (isRectangular) {
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
        borderSide: BorderSide(color: borderColor, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        fontFamily: 'Roboto',
        color: textFormBlack,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  } else {
    return InputDecoration(
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      // enabledBorder: const UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.black, width: 2),
      // ),
      // focusedBorder: const UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.black, width: 2),
      // ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: textFormError, width: 2),
      ),
      errorStyle: const TextStyle(color: textFormError),
      helperText: null,
      hintText: null,
      hintStyle: const TextStyle(
        color: textFormBlack,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
