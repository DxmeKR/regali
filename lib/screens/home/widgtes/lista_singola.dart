import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/prodotto.dart';
import '../../../utils/globals.dart';
import '../../prodotto/prodotto_page.dart';

class ListaSingola extends StatelessWidget {
  final Prodotto prodotto;
  const ListaSingola({super.key, required this.prodotto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(ProdottoPage.routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
              child: Container(
                color: Colors.grey[850],
                child: Builder(
                  builder: (_) {
                    final src = prodotto.immagineUrl;
                    if (src == null || src.trim().isEmpty) {
                      return const Center(
                        child: Icon(
                          Icons.card_giftcard,
                          color: kPrimary,
                          size: 36,
                        ),
                      );
                    }
                    try {
                      final s = src.trim();
                      Widget img;
                      if (s.startsWith('data:')) {
                        final base64Str = s.split(',').last;
                        final bytes = base64Decode(base64Str);
                        img = Image.memory(bytes, fit: BoxFit.cover);
                      } else {
                        final base64Regex = RegExp(r'^[A-Za-z0-9+/=\s]+$');
                        if (base64Regex.hasMatch(s) || s.length > 200) {
                          final bytes = base64Decode(s);
                          img = Image.memory(bytes, fit: BoxFit.cover);
                        } else if (s.startsWith('http')) {
                          img = Image.network(
                            s,
                            fit: BoxFit.cover,
                            loadingBuilder: (c, child, progress) =>
                                progress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                              size: 36,
                            ),
                          );
                        } else {
                          img = Image.asset(
                            s,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                              size: 36,
                            ),
                          );
                        }
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox.expand(child: img),
                      );
                    } catch (_) {
                      return const Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 36,
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SelectableText(
                prodotto.nome,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
