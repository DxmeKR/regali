import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
// MODELS
import '../../../models/prodotto.dart';
// SETTINGS
import '../../../utils/globals.dart';

class CardLista extends StatelessWidget {
  final Prodotto prodotto;
  const CardLista({super.key, required this.prodotto});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        prodotto.immagineUrl != null && prodotto.immagineUrl!.isNotEmpty;
    final imageUrl = hasImage ? prodotto.immagineUrl! : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        spacing: 16,
        children: [
          // Immagine / placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: kImageSize,
              height: kImageSize,
              color: Colors.grey[850],
              child: imageUrl != null
                  ? Builder(
                      builder: (_) {
                        try {
                          // se è una data URI: "data:image/png;base64,...."
                          if (imageUrl.startsWith('data:')) {
                            final base64Str = imageUrl.split(',').last;
                            final bytes = base64Decode(base64Str);
                            return Image.memory(bytes, fit: BoxFit.cover);
                          }
                          // se è una stringa base64 pura (molto lunga, senza header)
                          if (RegExp(
                                r'^[A-Za-z0-9+/=\s]+\$',
                              ).hasMatch(imageUrl) ||
                              imageUrl.length > 200) {
                            final bytes = base64Decode(imageUrl);
                            return Image.memory(bytes, fit: BoxFit.cover);
                          }
                          // se è un URL remoto
                          if (imageUrl.startsWith('http')) {
                            return Image.network(imageUrl, fit: BoxFit.cover);
                          }
                          // fallback a asset locale
                          return Image.asset(imageUrl, fit: BoxFit.cover);
                        } catch (_) {
                          return const Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 36,
                          );
                        }
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.card_giftcard,
                        color: kPrimary,
                        size: 36,
                      ),
                    ),
            ),
          ),
          // Dettagli
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                FittedBox(
                  child: Text(
                    prodotto.nome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kAccent,
                    ),
                  ),
                ),

                FittedBox(
                  child: InkWell(
                    onTap: () async {
                      final url = prodotto.url;
                      if (url != null && url.isNotEmpty) {
                        try {
                          final ok = await launchUrlString(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                          if (!ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Impossibile aprire il link'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Errore apertura link: $e'),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Text(
                      prodotto.url ?? '',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                    ),
                  ),
                ),

                FittedBox(
                  child: Text(
                    prodotto.descrizione ?? '',
                    style: TextStyle(color: kMutedText, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: Text(
                        prodotto.prezzo != null
                            ? '€ ${prodotto.prezzo!.toStringAsFixed(2)}'
                            : '—',
                        style: const TextStyle(
                          color: kAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        prodotto.isChecked ? 'No' : 'Sì',
                        style: TextStyle(
                          color: prodotto.isChecked ? kUnavailable : kAvailable,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
