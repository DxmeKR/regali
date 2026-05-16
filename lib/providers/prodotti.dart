import 'package:cloud_firestore/cloud_firestore.dart';
// MODELS
import '../models/prodotto.dart';

class Prodotti {
  CollectionReference collection = FirebaseFirestore.instance.collection(
    'prodottoUtente',
  );

  /// Recupera i prodotti per un utente specifico
  Stream<List<Prodotto>> fetch(String uid) {
    try {
      return collection
          .doc(uid)
          .collection("prodotti")
          .snapshots()
          .map(
            (QuerySnapshot snapshot) =>
                snapshot.docs.map((doc) => Prodotto.imposta(doc, uid)).toList(),
          );
    } catch (error) {
      throw Exception('Errore nel recupero del prodotto: $error');
    }
  }

  /// Aggiunge un nuovo prodotto per un utente specifico
  Future<void> addProdotto(Prodotto prodotto) async {
    try {
      final creaDocumento = collection
          .doc(prodotto.uid)
          .collection("prodotti")
          .doc();

      await creaDocumento.set({
        'nome': prodotto.nome,
        'immagineUrl': prodotto.immagineUrl,
        'descrizione': prodotto.descrizione,
        'url': prodotto.url,
        'prezzo': prodotto.prezzo,
        'isChecked': prodotto.isChecked,
        'dataCreazione': Timestamp.fromDate(DateTime.now()),
        'dataUpdate': Timestamp.fromDate(DateTime.now()),
      });
    } catch (error) {
      throw Exception('Errore nell\'aggiunta del prodotto: $error');
    }
  }

  /// Modifica prodotto esistente
  Future<void> updateProdotto(Prodotto prodotto) async {
    try {
      final documento = collection
          .doc(prodotto.uid)
          .collection("prodotti")
          .doc(prodotto.idProdotto);

      await documento.update({
        'nome': prodotto.nome,
        'immagineUrl': prodotto.immagineUrl,
        'descrizione': prodotto.descrizione,
        'url': prodotto.url,
        'prezzo': prodotto.prezzo,
        'isChecked': prodotto.isChecked,
        'dataUpdate': Timestamp.fromDate(DateTime.now()),
      });
    } catch (error) {
      throw Exception('Errore nell\'aggiornamento del prodotto: $error');
    }
  }
}
