import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// MODEL
import '../../../models/prodotto.dart';
// WIDGET
import '../../../utils/widget/my_foto.dart';
import '../../prodotto/prodotto_page.dart';

class ListaHome extends StatelessWidget {
  final Prodotto? prodotto;
  const ListaHome({super.key, this.prodotto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (prodotto != null) {
          context.go('${ProdottoPage.routeName}/${prodotto!.idProdotto}');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: prodotto!.isChecked ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: MyFoto(prodotto: prodotto),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: SelectableText(
                prodotto?.nome ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: SelectableText(
                "€ ${prodotto?.prezzo?.toStringAsFixed(2).replaceAll(".", ",") ?? '0.00'}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
