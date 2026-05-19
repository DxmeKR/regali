import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:regali/utils/globals.dart';

import '../../models/prodotto.dart';

class MyFoto extends StatelessWidget {
  final Prodotto? prodotto;
  const MyFoto({super.key, this.prodotto});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Colors.grey[850],
      ),
      child: Builder(
        builder: (_) {
          final src = prodotto?.immagineUrl;
          if (src == null || src.trim().isEmpty) {
            return const Center(
              child: Icon(Icons.card_giftcard, color: kPrimary, size: 36),
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
                  loadingBuilder: (c, child, progress) => progress == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
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
    );
  }
}
