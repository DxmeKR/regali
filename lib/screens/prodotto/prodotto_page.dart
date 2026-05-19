import 'package:flutter/material.dart';
import 'package:regali/utils/globals.dart';
import 'package:url_launcher/url_launcher_string.dart';
// MODEL
import '../../models/prodotto.dart';
// PROVIDER
import '../../providers/prodotti.dart';
// WIDGET
import '../../utils/settings/my_button.dart';
import '../../utils/settings/my_scaffold.dart';
import '../../utils/widget/my_foto.dart';

class ProdottoPage extends StatefulWidget {
  final Prodotto? prodotto;
  final String? idProdotto;
  static const routeName = '/prodotto';

  const ProdottoPage({super.key, this.prodotto, this.idProdotto});

  @override
  State<ProdottoPage> createState() => _ProdottoPageState();
}

class _ProdottoPageState extends State<ProdottoPage> {
  bool _isUnavailable = false;

  @override
  void initState() {
    super.initState();
    // inizializza dallo model se presente
    // _isUnavailable = widget.prodotto?.nonDisponibile ?? false;
    _isUnavailable = false;
  }

  Future<void> _confirmToggleUnavailable() async {
    if (_isUnavailable) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Conferma scelta regalo',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Confermando, renderai questo regalo non disponibile per gli altri.\nSei sicuro di voler procedere?',
          style: TextStyle(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.9),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Conferma'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final uid = widget.prodotto?.uid;
    final idProdotto = widget.prodotto?.idProdotto ?? widget.idProdotto;

    if (uid == null || idProdotto == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Utente o prodotto non valido'),
            backgroundColor: Colors.orange.shade700,
          ),
        );
      }
      return;
    }

    try {
      await Prodotti().setChecked(uid, idProdotto);
      if (!mounted) return;
      setState(() => _isUnavailable = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prodotto segnato come non disponibile'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  Future<void> _openUrl(String url) async {
    try {
      final ok = await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossibile aprire il link')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Errore apertura link: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final minHeight = MediaQuery.of(context).size.height;

    return MyScaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight - heightBanner),
          child: SafeArea(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TOP: contenuto
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // foto
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: MyFoto(prodotto: widget.prodotto),
                        ),
                        // badge
                        if (_isUnavailable)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'NON DISPONIBILE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        // info prodotto
                        Text(
                          widget.prodotto?.nome ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.prodotto?.descrizione != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.prodotto!.descrizione!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                        if (widget.prodotto?.prezzo != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            '€${widget.prodotto!.prezzo!.toStringAsFixed(2).replaceAll(".", ",")}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: MyButton(
                              onPressed: _isUnavailable
                                  ? null
                                  : _confirmToggleUnavailable,
                              backTextColor: _isUnavailable
                                  ? MyButtonColor.messe
                                  : MyButtonColor.rosso,
                              text: _isUnavailable
                                  ? "E' stato scelto"
                                  : 'Scegli regalo',
                            ),
                          ),
                          if ((widget.prodotto?.url ?? '').isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: MyButton(
                                onPressed: () =>
                                    _openUrl(widget.prodotto!.url!),
                                backTextColor: MyButtonColor.messe,
                                text: "Vai al sito",
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
