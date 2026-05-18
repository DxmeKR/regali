import 'package:cloud_firestore/cloud_firestore.dart';

class Prodotto {
  final String uid;
  final String idProdotto;
  final String nome;
  final String? immagineUrl;
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
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Prodotto(
      uid: uid,
      idProdotto: doc.id,
      nome: data['nome'] as String? ?? '',
      immagineUrl: data['immagineUrl'] as String? ?? '',

      descrizione: data['descrizione'] as String?,
      url: data['url'] as String?,
      prezzo: data['prezzo'] != null
          ? (data['prezzo'] as num).toDouble()
          : null,
      isChecked: data['isChecked'] as bool? ?? false,
      dataCreazione: (data['dataCreazione'] as Timestamp).toDate(),
      dataUpdate: (data['dataUpdate'] as Timestamp).toDate(),
    );
  }
}
