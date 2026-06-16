import 'package:flutter/material.dart';
// PROVIDER
import '../../providers/prodotti.dart';
// UTILS
import '../../utils/globals.dart';
import '../../utils/settings/loading.dart';
// WIDGETS
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 231, 199, 192),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.brown),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              headTab,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            color: Colors.transparent,
                            elevation: 0,
                            icon: const Icon(Icons.help_outline),

                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    enabled: false,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            spacing: 12,
                                            children: [
                                              Text(
                                                ' Come funziona',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            color: Colors.grey.shade50,

                                            child: const Text(
                                              '1. Consulta i regali disponibili\n'
                                              '2. Seleziona quello che desideri\n'
                                              '3. Selezionando un regalo dalla lista e spuntandolo con "Scegli regalo" lo renderai non disponible agli altri ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black87,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                          ),
                        ],
                      ),
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
