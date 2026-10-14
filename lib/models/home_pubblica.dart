// MODEL
import './prodotto.dart';
import './utente.dart';

class HomeData {
  final Utente? utente;
  final List<Prodotto> prodotti;
  HomeData({required this.utente, required this.prodotti});
}
