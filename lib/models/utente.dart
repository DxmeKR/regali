import 'package:cloud_firestore/cloud_firestore.dart';

class Utente {
  final String idUtente;
  final String email;
  final bool isActive;
  final DateTime dataCreazione;
  final DateTime dataUpdate;

  Utente({
    required this.idUtente,
    required this.email,
    this.isActive = true,
    required this.dataCreazione,
    required this.dataUpdate,
  });

  factory Utente.imposta(DocumentSnapshot doc) {
    return Utente(
      idUtente: doc.id,
      email: doc['email'] ?? '',
      isActive: doc['isActive'] ?? true,
      dataCreazione: (doc['dataCreazione'] as Timestamp).toDate(),
      dataUpdate: (doc['dataUpdate'] as Timestamp).toDate(),
    );
  }
}
