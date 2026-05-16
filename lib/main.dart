import 'package:flutter/material.dart';
import 'package:regali/utils/settings/my_router.dart';

import 'utils/globals.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: myRouter,
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
