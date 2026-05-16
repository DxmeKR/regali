import 'package:flutter/material.dart';

class MyScaffoldAuth extends StatelessWidget {
  final Widget child;
  const MyScaffoldAuth({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,

        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: Center(child: child)),
      ),
    );
  }
}
