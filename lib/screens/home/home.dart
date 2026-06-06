import 'package:flutter/material.dart';
// PROVIDER
import '../../providers/prodotti.dart';
// UTILS
import '../../utils/globals.dart';
// WIDGETS
import '../../utils/settings/loading.dart';
import '../../utils/settings/my_scaffold.dart';
import './widgtes/lista_home.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Prodotti().fetchAll(onlyAvailable: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Loading();
        } else if (snapshot.hasError) {
          return Center(child: Text('Errore: ${snapshot.error}'));
        } else {
          final listaProdotti = snapshot.data ?? [];
          final prodottiDisponibili = listaProdotti
            ..sort(
              (a, b) =>
                  a.isChecked.toString().compareTo(b.isChecked.toString()),
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

                  // ListView dei regali da inserire
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width > 800
                            ? 32
                            : 16,
                        vertical: 8,
                      ),
                      itemCount: prodottiDisponibili.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        return ListaHome(prodotto: prodottiDisponibili[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
