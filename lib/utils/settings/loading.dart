import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final double size;
  final Color? color;
  const Loading({super.key, this.size = 50.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(color: color ?? Colors.black, size: size),
    );
  }
}
