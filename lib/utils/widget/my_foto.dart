import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/prodotto.dart';
import '../../utils/globals.dart';

class MyFoto extends StatelessWidget {
  final Prodotto? prodotto;

  const MyFoto({super.key, this.prodotto});

  @override
  Widget build(BuildContext context) {
    final bool isUnavailable = prodotto?.isChecked ?? false;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _ProductImage(prodotto: prodotto),

            if (isUnavailable) const _UnavailableOverlay(),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Prodotto? prodotto;

  const _ProductImage({required this.prodotto});

  @override
  Widget build(BuildContext context) {
    final src = prodotto?.immagineUrl;

    if (src == null || src.trim().isEmpty) {
      return const Center(
        child: Icon(Icons.card_giftcard, color: kPrimary, size: 48),
      );
    }

    try {
      final s = src.trim();

      if (s.startsWith('data:')) {
        final base64Str = s.split(',').last;
        final bytes = base64Decode(base64Str);

        return Image.memory(bytes, fit: BoxFit.cover);
      }

      final base64Regex = RegExp(r'^[A-Za-z0-9+/=\s]+$');

      if (base64Regex.hasMatch(s) || s.length > 200) {
        final bytes = base64Decode(s);

        return Image.memory(bytes, fit: BoxFit.cover);
      }

      if (s.startsWith('http')) {
        return Image.network(
          s,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;

            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
          errorBuilder: (_, _, _) {
            return const Center(
              child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
            );
          },
        );
      }

      return Image.asset(
        s,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return const Center(
            child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
          );
        },
      );
    } catch (_) {
      return const Center(
        child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
      );
    }
  }
}

class _UnavailableOverlay extends StatelessWidget {
  const _UnavailableOverlay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Blur
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(),
        ),

        // Overlay scuro
        Container(color: Colors.black.withValues(alpha: 0.45)),

        // Badge centrale
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.30),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.block, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'GIÀ SCELTO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
