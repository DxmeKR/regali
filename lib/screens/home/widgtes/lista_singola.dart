import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../prodotto/prodotto_page.dart';

class ListaSingola extends StatelessWidget {
  const ListaSingola({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(ProdottoPage.routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                'https://thumbs.dreamstime.com/b/superficie-praticante-il-surfing-dell-acqua-onda-di-oceano-mare-124362369.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SelectableText(
                'Nome del regalo',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
