import 'package:flutter/material.dart';

import '../../utils/globals.dart';
import '../../utils/settings/my_scaffold.dart';
import './widgtes/lista_singola.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        mainAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              headTab,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),

          // ListView dei regali da inserire
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 5,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                return ListaSingola();
              },
            ),
          ),
        ],
      ),
    );
  }
}
