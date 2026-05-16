import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../settings/my_button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});
  static const routeName = '/error';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          margin: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('OPS! SEMBRA CI SIA UN ERRORE'),
              const Text('La pagina che stai cercando non esiste.'),
              MyButton(
                onPressed: () => context.go('/'),
                text: 'Torna alla Home',
                backTextColor: MyButtonColor.secondaryButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
