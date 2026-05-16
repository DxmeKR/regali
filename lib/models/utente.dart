import 'package:cloud_firestore/cloud_firestore.dart';

class Utente {
  final String idUtente;
  final String email;
  final bool isActive;

  Utente({required this.idUtente, required this.email, this.isActive = true});

  factory Utente.imposta(DocumentSnapshot doc) {
    return Utente(
      idUtente: doc.id,
      email: doc['email'] ?? '',
      isActive: doc['isActive'] ?? true,
    );
  }
}
