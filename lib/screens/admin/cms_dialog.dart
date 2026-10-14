import 'package:flutter/material.dart';
// PROVIDER
import '../../providers/provider_home.dart';
//WIDGET
import '../../utils/form/my_text_formfield.dart';
import '../../utils/settings/loading.dart';

class ImpostazioniDialog extends StatefulWidget {
  final String uid;
  const ImpostazioniDialog({super.key, required this.uid});

  static Future<void> show(BuildContext context, String uid) {
    return showDialog(
      context: context,
      builder: (_) => ImpostazioniDialog(uid: uid),
    );
  }

  @override
  State<ImpostazioniDialog> createState() => _ImpostazioniDialogState();
}

class _ImpostazioniDialogState extends State<ImpostazioniDialog> {
  final TextEditingController _description = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _carica();
  }

  @override
  void dispose() {
    _description.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  Future<void> _carica() async {
    try {
      final data = await ProviderHome().fetchImpostazioni(widget.uid);
      if (data != null) {
        _description.text = data['description'] as String? ?? '';
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _salva() async {
    setState(() => _saving = true);
    try {
      await ProviderHome().saveImpostazioni(
        widget.uid,
        description: _description.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Errore nel salvataggio: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Impostazioni sito'),
      content: SizedBox(
        width: 500,
        height: 250,
        child: _loading
            ? Loading()
            : MyTextFormField(
                titolo: "Descrizione",
                isTitoloRequired: false, // <-- sblocca l'altezza personalizzata
                height: 140, // ~5 righe
                focusNode: _descriptionFocus,
                controller: _description,
                hintText: "Descrizione",
                maxLength: 500,
                maxLines: 5,
                validator: (v) => null,
              ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: (_loading || _saving) ? null : _salva,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Salva'),
        ),
      ],
    );
  }
}
