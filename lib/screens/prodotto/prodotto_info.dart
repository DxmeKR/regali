import 'package:flutter/material.dart';
// MODEL
import '../../models/prodotto.dart';

class ProdottoInfo extends StatelessWidget {
  final Prodotto? prodotto;
  const ProdottoInfo({super.key, required this.prodotto});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // info prodotto
        Text(
          prodotto?.nome ?? '',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        if (prodotto?.descrizione != null) ...[
          const SizedBox(height: 8),
          Text(
            prodotto!.descrizione!,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
        if (prodotto?.prezzo != null) ...[
          const SizedBox(height: 12),
          Text(
            '€${prodotto!.prezzo!.toStringAsFixed(2).replaceAll(".", ",")}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ],
    );
  }
}
