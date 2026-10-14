import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regali/models/utente.dart';
import 'package:rxdart/rxdart.dart';
//MODEL
import '../models/home_pubblica.dart';
import '../models/prodotto.dart';

class ProviderHome {
  CollectionReference collection = FirebaseFirestore.instance.collection(
    'prodottoUtente',
  );

  Stream<HomeData> fetchHome({bool onlyAvailable = false}) {
    final utentiAttivi = FirebaseFirestore.instance
        .collection('utenti') // nome reale della tua collection
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots();

    return utentiAttivi.switchMap((snapUtenti) {
      if (snapUtenti.docs.isEmpty) {
        return Stream.value(HomeData(utente: null, prodotti: []));
      }

      final userDoc = snapUtenti.docs.first;
      final utente = Utente.imposta(userDoc);

      Query query = collection.doc(utente.idUtente).collection('prodotti');
      // if (onlyAvailable) {
      //   query = query.where('isChecked', isEqualTo: false);
      // }

      return query.snapshots().map(
        (snap) => HomeData(
          utente: utente,
          prodotti: snap.docs
              .map((d) => Prodotto.imposta(d, utente.idUtente))
              .toList(),
        ),
      );
    });
  }

  Future<Map<String, dynamic>?> fetchImpostazioni(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('utenti')
        .doc(uid)
        .get();
    return doc.data();
  }

  Future<void> saveImpostazioni(
    String uid, {
    // required String appTitle,
    // required String titleBanner,
    required String description,
    // required Color bannerColor,
  }) {
    return FirebaseFirestore.instance.collection('utenti').doc(uid).set({
      // 'appTitle': appTitle,
      // 'titleBanner': titleBanner,
      'description': description,
      // 'bannerColor': bannerColor.toARGB32(), // Flutter < 3.27: usa .value
      'dataUpdate': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
  }
}
