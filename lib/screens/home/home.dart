import 'package:flutter/material.dart';
//MODEL
import '../../models/home_pubblica.dart';
// import '../../models/prodotto.dart';
// // PROVIDER
import '../../providers/provider_home.dart';
// import '../../providers/prodotti.dart';
// UTILS
import '../../utils/settings/loading.dart';
// WIDGETS
import '../../utils/settings/my_scaffold.dart';
import './widgtes/lista_home.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Stream<HomeData> _stream;

  @override
  void initState() {
    super.initState();
    _stream = ProviderHome().fetchHome(onlyAvailable: true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeData>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Errore: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Loading();
        }

        final utente = snapshot.data!.utente;
        if (utente == null) {
          return const Center(child: Text('Nessuna lista disponibile'));
        }

        final prodottiDisponibili = [...snapshot.data!.prodotti]
          ..sort((a, b) => b.dataCreazione.compareTo(a.dataCreazione));
        return MyScaffold(
          body: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4EC), // Rosa cipria tenue
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE8A1B3), // Bordo rosa delicato
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              utente.description,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            tooltip: 'Come funziona',
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
                                              '3. Selezionando un regalo dalla lista e spuntandolo con "Scegli regalo" lo renderai non disponibile agli altri ',
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
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 800
                        ? 32
                        : 16,
                    vertical: 8,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          ListaHome(prodotto: prodottiDisponibili[index]),
                      childCount: prodottiDisponibili.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.1,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
