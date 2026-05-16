import 'package:go_router/go_router.dart';
import '../../models/prodotto.dart';
import '../../screens/auth/login.dart';
import '../../screens/home/home.dart';
import '../../screens/prodotto/prodotto_page.dart';
import '../widget/error_page.dart';

final GoRouter myRouter = GoRouter(
  initialLocation: HomePage.routeName,
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    // LOGIN
    GoRoute(
      path: LoginPage.routeName,
      builder: (context, state) => const LoginPage(),
      // redirect: (context, state) {
      //   // Se l'utente è già loggato, reindirizza alla home
      //   // if (Provider.of<Auth>(context, listen: false).isLoggedIn) {
      //   //   return AdminPage.routeName;
      //   // }
      //   return null; // Altrimenti, resta sulla pagina di login
      // },
    ),
    // PRENOTAZIONE MESSE
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) {
        // final int currentAnno = DateTime.now().year;
        // final int currentMese = DateTime.now().month;
        // MessePrenotate messe = Provider.of<MessePrenotate>(
        //   context,
        //   listen: true,
        // );
        // List<MessaPrenotata> messePrenotate = Provider.of<List<MessaPrenotata>>(
        //   context,
        //   listen: true,
        // );
        // messe.setLista(messePrenotate);
        // messe.setMessePrenotateMonth(
        //   messePrenotate
        //       .where(
        //         (messa) =>
        //             messa.data.month == currentMese &&
        //             messa.data.year == currentAnno,
        //       )
        //       .toList(),
        // );

        // messe.setMesseNonCelebrate(
        //   messePrenotate
        //       .where((messa) => messa.idCelebrate.length < messa.numeroMesse)
        //       .toList(),
        // );

        return HomePage();
      },
    ),
    // PRENOTAZIONE MESSE con Anno e Mese
    // GoRoute(
    //   path: "${PrenotazioneMesseScreen.routeName}/:anno/:mese",
    //   builder: (context, state) {
    //     final params = state.pathParameters;
    //     final String anno = params['anno'] ?? DateTime.now().year.toString();
    //     final String mese = params['mese'] ?? DateTime.now().month.toString();
    //     MessePrenotate messe = Provider.of<MessePrenotate>(
    //       context,
    //       listen: true,
    //     );
    //     List<MessaPrenotata> messePrenotate = Provider.of<List<MessaPrenotata>>(
    //       context,
    //       listen: true,
    //     );
    //     messe.setLista(messePrenotate);
    //     messe.setMessePrenotateMonth(
    //       messePrenotate
    //           .where(
    //             (messa) =>
    //                 messa.data.month == int.parse(mese) &&
    //                 messa.data.year == int.parse(anno),
    //           )
    //           .toList(),
    //     );

    //     messe.setMesseNonCelebrate(
    //       messePrenotate
    //           .where((messa) => messa.idCelebrate.length < messa.numeroMesse)
    //           .toList(),
    //     );
    //     return PrenotazioneMesseScreen(
    //       anno: int.parse(anno),
    //       mese: int.parse(mese),
    //     );
    //   },
    // ),

    //Archivio
    GoRoute(
      path: ProdottoPage.routeName,
      builder: (context, state) {
        return ProdottoPage(
          prodotto: Prodotto(
            uid: "123",
            idProdotto: "1",
            nome: "Prodotto 1",
            descrizione: "Descrizione del prodotto 1",
            isChecked: false,
            prezzo: 2.0,
            url: "https://example.com/prodotto",
            immagineUrl: [
              'https://thumbs.dreamstime.com/b/superficie-praticante-il-surfing-dell-acqua-onda-di-oceano-mare-124362369.jpg',

              "https://kinsta.com/wp-content/uploads/2020/08/tiger-jpg.jpg",
            ],
          ),
        );

        // FiltriArchivio filtro = Provider.of<FiltriArchivio>(context);
        // Convento convento = Provider.of<Convento>(context);
        // filtro.setAnni(convento.idConvento);

        // );
      },
    ),
  ],
);
