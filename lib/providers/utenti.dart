import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/utente.dart';
import 'package:flutter/material.dart';

class Utenti extends ChangeNotifier {
  CollectionReference collection = FirebaseFirestore.instance.collection(
    'users',
  );

  Stream<Utente> fetch(String id) {
    try {
      return collection.doc(id).snapshots().map((doc) => Utente.imposta(doc));
    } catch (error) {
      throw Exception('Errore nel recupero dell\'utente: $error');
    }
  }
}
