import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/prodotto.dart';
import '../../utils/globals.dart';
import '../../utils/settings/my_button.dart';
import '../../utils/settings/my_scaffold.dart';
import '../admin/admin.dart';
import './widgtes/lista_singola.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Prodotto> prodotti = Provider.of<List<Prodotto>>(
      context,
      listen: true,
    );
    return MyScaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
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
            MyButton(
              text: 'Aggiungi regalo',
              onPressed: () {
                context.go(AdminScreen.routeName);
              },
            ),
            // ListView dei regali da inserire
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 800 ? 32 : 16,
                  vertical: 8,
                ),
                itemCount: prodotti.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  return ListaSingola(prodotto: prodotti[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
