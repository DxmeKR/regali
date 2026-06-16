import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// WIDGET
import '../../screens/auth/login.dart';
import '../../screens/home/home.dart';
import '../../screens/home/widgtes/banner.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isHome = location == '/';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: double.infinity,
        toolbarHeight: 130,
        leading: Stack(
          children: [
            GestureDetector(
              child: BannerHead(),
              onDoubleTap: () => context.push(LoginPage.routeName),
            ),
            SafeArea(
              child: !isHome
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            color: const Color.fromARGB(255, 231, 199, 192),
                            iconSize: 28,
                            onPressed: () => context.go(HomePage.routeName),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      body: Column(children: [Expanded(child: body)]),
    );
  }
}
