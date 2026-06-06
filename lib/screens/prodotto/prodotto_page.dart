import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
// MODEL
import '../../models/prodotto.dart';
// PROVIDER
import '../../providers/prodotti.dart';
// WIDGET
import '../../utils/settings/my_button.dart';
import '../../utils/settings/my_scaffold.dart';
import '../../utils/widget/my_foto.dart';
import './prodotto_info.dart';

class ProdottoPage extends StatefulWidget {
  final String idProdotto;

  static const routeName = '/prodotto';

  const ProdottoPage({super.key, required this.idProdotto});

  @override
  State<ProdottoPage> createState() => _ProdottoPageState();
}

class _ProdottoPageState extends State<ProdottoPage> {
  bool _isUnavailable = false;

  Future<void> _setNonDisponibile(Prodotto prodotto) async {
    if (_isUnavailable) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Conferma scelta regalo'),
        content: const Text(
          'Confermando, il regalo verrà segnato come non disponibile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Conferma'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await Prodotti().setChecked(prodotto.uid, prodotto.idProdotto);

      setState(() => _isUnavailable = true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prodotto segnato come non disponibile'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Errore: $e')));
      }
    }
  }

  Future<void> _openUrl(String url) async {
    try {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Prodotto?>(
      stream: Prodotti().fetchSingle(widget.idProdotto),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MyScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final prodotto = snapshot.data;

        if (prodotto == null) {
          return const MyScaffold(
            body: Center(child: Text("Prodotto non trovato")),
          );
        }

        return MyScaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: MyFoto(prodotto: prodotto),
                  ),

                  ProdottoInfo(prodotto: prodotto),

                  Row(
                    children: [
                      if (!prodotto.isChecked)
                        Expanded(
                          child: MyButton(
                            text: _isUnavailable
                                ? "E' stato scelto"
                                : "Scegli regalo",
                            backTextColor: _isUnavailable
                                ? MyButtonColor.messe
                                : MyButtonColor.rosso,
                            onPressed: _isUnavailable
                                ? null
                                : () => _setNonDisponibile(prodotto),
                          ),
                        ),

                      if ((prodotto.url ?? '').isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: MyButton(
                            text: "Vai al sito",
                            backTextColor: MyButtonColor.messe,
                            onPressed: () => _openUrl(prodotto.url!),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
