import 'package:cloud_firestore/cloud_firestore.dart';

class Utente {
  final String idUtente;
  final String email;
  final bool isActive;
  final String description;
  final DateTime dataCreazione;
  final DateTime dataUpdate;

  Utente({
    required this.idUtente,
    required this.email,
    this.isActive = false,
    this.description = '',
    required this.dataCreazione,
    required this.dataUpdate,
  });

  factory Utente.imposta(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Utente(
      idUtente: doc.id,
      email: data['email'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? false,
      description: data['description'] as String? ?? '',
      dataCreazione: (data['dataCreazione'] as Timestamp).toDate(),
      dataUpdate: (data['dataUpdate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'isActive': isActive,
    'description': description,
    'dataUpdate': Timestamp.fromDate(DateTime.now()),
  };
}
