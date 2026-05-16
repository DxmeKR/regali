import 'package:cloud_firestore/cloud_firestore.dart';

class Prodotto {
  final String uid;
  final String idProdotto;
  final String nome;
  final List<String>? immagineUrl;
  final String? descrizione;
  final String? url;
  final double? prezzo;
  final bool isChecked;
  final DateTime dataCreazione;
  final DateTime dataUpdate;

  Prodotto({
    required this.uid,
    required this.idProdotto,
    required this.nome,
    this.immagineUrl,
    this.descrizione,
    this.url,
    this.prezzo,
    this.isChecked = false,
    required this.dataCreazione,
    required this.dataUpdate,
  });

  factory Prodotto.imposta(DocumentSnapshot doc, String uid) {
    return Prodotto(
      uid: uid,
      idProdotto: doc.id,
      nome: doc['nome'],
      immagineUrl: doc['immagineUrl'],
      descrizione: doc['descrizione'],
      url: doc['url'],
      prezzo: doc['prezzo'],
      isChecked: doc['isChecked'] ?? false,
      dataCreazione: (doc['dataCreazione'] as Timestamp).toDate(),
      dataUpdate: (doc['dataUpdate'] as Timestamp).toDate(),
    );
  }
}
