import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

//PROVIDER
import '../../../providers/auth.dart';
import '../../../providers/prodotti.dart';
import '../../../providers/utenti.dart';
//MODEL
import '../../../models/prodotto.dart';
import '../../../models/utente.dart';

//WIDGET
import '../../../utils/settings/loading.dart';

class StreamBuilders extends StatelessWidget {
  final Widget body;
  const StreamBuilders({super.key, required this.body});
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: true);
    return !auth.isAuth
        ? const Scaffold(backgroundColor: Colors.white, body: Loading())
        : StreamBuilder(
            stream: Rx.combineLatest2(
              Utenti().fetch(auth.uid!),
              Prodotti().fetch(auth.uid!),
              (utente, prodotto) => (utente: utente, prodotto: prodotto),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Loading(),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Text(
                    "Errore negli stream: ${snapshot.error}\n"
                    "dati nello snapshot: ${snapshot.data}",
                  ),
                );
              } else {
                return MultiProvider(
                  providers: [
                    Provider<Utente>.value(value: snapshot.data!.utente),
                    Provider<List<Prodotto>>.value(
                      value: snapshot.data!.prodotto,
                    ),
                  ],
                  child: body,
                );
              }
            },
          );
  }
}
