import 'package:cloud_firestore/cloud_firestore.dart';
// MODELS
import '../models/prodotto.dart';

class Prodotti {
  CollectionReference collection = FirebaseFirestore.instance.collection(
    'prodottoUtente',
  );

  /// Devo fetchare i prodotti in generale per mostrarli nella home,
  /// e mostrare solo i prodotti
  /// degli utenti attivi

  Stream<List<Prodotto>> fetchAll({bool onlyAvailable = false}) {
    try {
      Query query = FirebaseFirestore.instance.collectionGroup('prodotti');
      if (onlyAvailable) {
        query = query.where('isChecked', isEqualTo: false);
      }
      return query.snapshots().map((QuerySnapshot snapshot) {
        final list = snapshot.docs.map((doc) {
          // recupera l'uid dal path: prodottoUtente/{uid}/prodotti/{docId}
          final uid = doc.reference.parent.parent?.id ?? '';
          return Prodotto.imposta(doc, uid);
        }).toList();
        return list;
      });
    } catch (error) {
      throw Exception('Errore nel recupero dei prodotti: $error');
    }
  }

  /// Recupera i prodotti per un utente specifico
  ///
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

  /// Delete prodotto
  Future<void> deleteProdotto(Prodotto prodotto) async {
    try {
      final docRef = collection
          .doc(prodotto.uid)
          .collection('prodotti')
          .doc(prodotto.idProdotto);
      await docRef.delete();
    } catch (error) {
      throw Exception('Errore nell\'eliminazione del prodotto: $error');
    }
  }

  /// Setta il prodotto isChecked a true (non disponibile)
  Future<void> setChecked(String uid, String idProdotto) async {
    try {
      final documento = collection
          .doc(uid)
          .collection("prodotti")
          .doc(idProdotto);

      await documento.update({
        'isChecked': true,
        'dataUpdate': Timestamp.fromDate(DateTime.now()),
      });
    } catch (error) {
      throw Exception(
        'Errore nel segnare il prodotto come non disponibile: $error',
      );
    }
  }
}
