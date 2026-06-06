import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// PROVIDER
import '../../providers/auth.dart';
// SCREENS
import '../../screens/admin/admin.dart';
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
      redirect: (context, state) {
        if (Provider.of<Auth>(context, listen: false).isAuth) {
          return AdminScreen.routeName;
        }
        return null;
      },
    ),
    // PRENOTAZIONE MESSE
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) {
        return HomePage();
      },
    ),

    //Prodotto
    // GoRoute(
    //   path: '/prodotto/:id',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id'];
    //     final prodotto = state.extra as Prodotto?;

    //     return ProdottoPage(idProdotto: id, prodotto: prodotto);
    //   },
    // ),
    GoRoute(
      path: '${ProdottoPage.routeName}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProdottoPage(idProdotto: id);
      },
    ),
    GoRoute(
      path: AdminScreen.routeName,
      builder: (context, state) {
        return AdminScreen();
      },
      redirect: (context, state) {
        // se non autenticato, vai alla pagina di login (usata solo per accedere all'admin)
        if (!Provider.of<Auth>(context, listen: false).isAuth) {
          return LoginPage.routeName;
        }
        return null;
      },
    ),
  ],
);
