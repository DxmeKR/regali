import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../utils/settings/loading.dart';
import './stream_builder.dart';

class AuthBuilder extends StatelessWidget {
  final Widget body;
  const AuthBuilder({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: true);

    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, snapUserAuth) {
        if (snapUserAuth.connectionState != ConnectionState.active) {
          return const Scaffold(body: Loading());
        }

        if (snapUserAuth.data != null) {
          return StreamBuilders(body: body);
        }
        // Utente non autenticato - restituisci comunque body
        // Il redirect di GoRouter si occuperà di mostrare LoginPage
        return body;
      },
    );
  }
}
