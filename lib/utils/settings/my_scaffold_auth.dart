import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyScaffoldAuth extends StatelessWidget {
  final Widget child;
  final bool showBack;
  final String? title;
  const MyScaffoldAuth({
    required this.child,
    super.key,
    this.showBack = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: showBack
              ? InkWell(
                  onTap: () => context.go('/'),
                  child: const BackButton(color: Colors.black),
                )
              : null,
        ),
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(child: child),
              ),
            );
          },
        ),
      ),
    );
  }
}
