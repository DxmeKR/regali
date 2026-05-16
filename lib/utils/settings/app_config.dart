import 'package:firebase_core/firebase_core.dart';

import './firebase_options.dart' as fdev;
import './firebase_options.dart' as fprod;

//WIDGET

enum AppEnv { dev, prod }

class AppConfig {
  final AppEnv env;
  final FirebaseOptions firebaseOptions;

  const AppConfig._(this.env, this.firebaseOptions);

  static AppEnv _currentEnv() {
    const raw = String.fromEnvironment('ENV', defaultValue: 'dev');
    // const raw = String.fromEnvironment('ENV', defaultValue: 'prod');
    return (raw.toLowerCase() == 'prod') ? AppEnv.prod : AppEnv.dev;
  }

  // carica/init una sola volta (firebase incluso)
  static Future<AppConfig> load() async {
    final env = _currentEnv();
    final options = switch (env) {
      AppEnv.dev => fdev.DefaultFirebaseOptions.currentPlatform,
      AppEnv.prod => fprod.DefaultFirebaseOptions.currentPlatform,
    };

    await Firebase.initializeApp(options: options);

    return AppConfig._(env, options);
  }
}
