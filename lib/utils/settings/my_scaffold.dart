import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// WIDGET
import '../../screens/home/widgtes/banner.dart';
// SCREENS
import '../../screens/auth/login.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              InkWell(
                child: BannerHead(),
                onTap: () => context.push(LoginPage.routeName),
              ),
              SafeArea(
                child: Navigator.canPop(context)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Color.fromARGB(255, 231, 199, 192),
                          onPressed: () => context.pop(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
