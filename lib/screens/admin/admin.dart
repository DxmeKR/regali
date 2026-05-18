import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
// Providers
import '../../providers/prodotti.dart';
// Utils
import '../../utils/settings/loading.dart';
import '../../utils/settings/my_button.dart';
import '../../utils/settings/my_scaffold.dart';
// Widgets
import './widget/card_lista.dart';
import './widget/carica_prodotto.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin/home';
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: true);
    return StreamBuilder(
      stream: Prodotti().fetch(auth.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Loading();
        } else if (snapshot.hasError) {
          return Center(child: Text('Errore: ${snapshot.error}'));
        } else {
          final listaProdotti = snapshot.data ?? [];
          return MyScaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'I tuoi Regali',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${listaProdotti.length} elementi in lista',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      MyButton(
                        onPressed: () => CreateUpdateProdotto.show(context),
                        icon: Icon(Icons.add),
                        text: "Aggiungi",
                        isLoading: isLoading,
                        width: 120,
                        height: 40,
                      ),
                    ],
                  ),

                  // Lista dei regali (nel tuo caso qui metterai lo StreamBuilder)
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaProdotti.length,
                      itemBuilder: (context, index) {
                        return CardLista(prodotto: listaProdotti[index]);
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
