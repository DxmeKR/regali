import 'package:flutter/material.dart';

import '../../models/prodotto.dart';
import '../../utils/settings/my_button.dart';
import '../../utils/settings/my_scaffold.dart';
import './widget/carosello_foto.dart';

class ProdottoPage extends StatefulWidget {
  final Prodotto prodotto;
  static const routeName = '/prodotto';

  const ProdottoPage({super.key, required this.prodotto});

  @override
  State<ProdottoPage> createState() => _ProdottoPageState();
}

class _ProdottoPageState extends State<ProdottoPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 CAROSELLO FOTO
            CaroselloFoto(prodotto: widget.prodotto),
            // 📦 INFO PRODOTTO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Text(
                    widget.prodotto.nome,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Prezzo
                  if (widget.prodotto.prezzo != null)
                    Text(
                      '€${widget.prodotto.prezzo!.toStringAsFixed(2).replaceAll(".", ",")}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Descrizione
                  if (widget.prodotto.descrizione != null)
                    Text(
                      widget.prodotto.descrizione!,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),

                  const SizedBox(height: 24),

                  // 🔘 BOTTONE PRINCIPALE
                  if (widget.prodotto.url != null)
                    SizedBox(
                      width: double.infinity,
                      child: MyButton(
                        onPressed: () {
                          // Apri link
                        },
                        backTextColor: MyButtonColor.messe,
                        text: "Vai al sito",
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
