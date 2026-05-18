import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/prodotto.dart';
import '../../utils/settings/my_button.dart';
import '../../utils/settings/my_scaffold.dart';

class ProdottoPage extends StatefulWidget {
  static const routeName = '/prodotto';

  const ProdottoPage({super.key});

  @override
  State<ProdottoPage> createState() => _ProdottoPageState();
}

class _ProdottoPageState extends State<ProdottoPage> {
  @override
  Widget build(BuildContext context) {
    Prodotto prodotto = Provider.of<Prodotto>(context, listen: false);
    return MyScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 CAROSELLO FOTO
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                prodotto.immagineUrl ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
                errorBuilder: (_, _, _) {
                  return Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    height: 300,
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            // 📦 INFO PRODOTTO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Text(
                    prodotto.nome,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Prezzo
                  if (prodotto.prezzo != null)
                    Text(
                      '€${prodotto.prezzo!.toStringAsFixed(2).replaceAll(".", ",")}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                  // Descrizione
                  if (prodotto.descrizione != null)
                    Text(
                      prodotto.descrizione!,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),

                  // 🔘 BOTTONE PRINCIPALE
                  if (prodotto.url != null)
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
          ],
        ),
      ),
    );
  }
}
