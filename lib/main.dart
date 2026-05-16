import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './utils/globals.dart';
import './utils/settings/app_config.dart';
import './utils/settings/my_page_transition.dart';
import './utils/settings/my_router.dart';
import './screens/auth/state/auth_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeDateFormatting('it_IT');

  final config = await AppConfig.load();

  runApp(Provider<AppConfig>.value(value: config, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<Auth>.value(
      value: Auth(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: myRouter,
        title: appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: MyPageTransitionBuilder(),
              TargetPlatform.iOS: MyPageTransitionBuilder(),
              TargetPlatform.fuchsia: MyPageTransitionBuilder(),
              TargetPlatform.linux: MyPageTransitionBuilder(),
              TargetPlatform.macOS: MyPageTransitionBuilder(),
              TargetPlatform.windows: MyPageTransitionBuilder(),
            },
          ),
        ),
        builder: (context, child) => AuthBuilder(body: child!),
      ),
    );
  }
}
