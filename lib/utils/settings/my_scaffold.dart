import 'package:flutter/material.dart';

import '../../screens/home/widgtes/banner.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BannerHead(),
          Expanded(child: body),
        ],
      ),
    );
  }
}
