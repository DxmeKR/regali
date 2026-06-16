import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// Providers
import '../../providers/auth.dart';
import '../../providers/prodotti.dart';
// Utils
import '../../utils/settings/loading.dart';
import '../../utils/settings/my_button.dart';
import '../../utils/settings/my_scaffold.dart';
// Widgets
import '../home/home.dart';
import './widget/card_lista.dart';
import './widget/create_update_prodotto.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(
                          onPressed: () => CreateUpdateProdotto.show(context),
                          icon: Icon(Icons.add),
                          text: "Aggiungi",
                          isLoading: isLoading,
                          width: 120,
                          height: 40,
                          margin: EdgeInsets.zero,
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            MyButton(
                              onPressed: () => context.go(HomePage.routeName),
                              icon: Icon(Icons.home, color: Colors.lightBlue),
                              text: "",
                              backTextColor: MyButtonColor.secondaryButton,
                              isLoading: isLoading,
                              width: 50,
                              height: 40,
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                            ),
                            MyButton(
                              onPressed: () => Provider.of<Auth>(
                                context,
                                listen: false,
                              ).logout(),
                              icon: Icon(Icons.logout),
                              text: "",
                              backTextColor: MyButtonColor.rosso,
                              isLoading: isLoading,
                              width: 50,
                              height: 40,
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ],
                    ),
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
