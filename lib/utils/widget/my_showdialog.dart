import 'package:flutter/material.dart';

void myShowDialog(BuildContext context, Widget body) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return body;
    },
  );
}
