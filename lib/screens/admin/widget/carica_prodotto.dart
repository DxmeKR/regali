import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// MODELS
import '../../../models/prodotto.dart';
// PROVIDER
import '../../../providers/auth.dart';
import '../../../providers/prodotti.dart';
// WIDGET
import '../../../providers/utenti.dart';
import '../../../utils/form/my_text_formfield.dart';
import '../../../utils/settings/my_button.dart';

class CreateUpdateProdotto extends StatefulWidget {
  final bool isModifica;
  final Prodotto? prodotto;

  const CreateUpdateProdotto({
    super.key,
    required this.isModifica,
    this.prodotto,
  });

  static void show(
    BuildContext context, {
    bool isModifica = false,
    Prodotto? prodotto,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: const Color(0xFF1E1E24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return CreateUpdateProdotto(isModifica: isModifica, prodotto: prodotto);
      },
    );
  }

  @override
  State<CreateUpdateProdotto> createState() => _CreateUpdateProdottoState();
}

class _CreateUpdateProdottoState extends State<CreateUpdateProdotto> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descrizioneController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _prezzoController = TextEditingController();

  final FocusNode _nomeFocus = FocusNode();
  final FocusNode _descrizioneFocus = FocusNode();
  final FocusNode _urlFocus = FocusNode();
  final FocusNode _prezzoFocus = FocusNode();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.isModifica && widget.prodotto != null) {
      _nomeController.text = widget.prodotto!.nome;
      _descrizioneController.text = widget.prodotto!.descrizione ?? '';
      _urlController.text = widget.prodotto!.url ?? '';
      _prezzoController.text = widget.prodotto!.prezzo?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descrizioneController.dispose();
    _urlController.dispose();
    _prezzoController.dispose();

    _nomeFocus.dispose();
    _descrizioneFocus.dispose();
    _urlFocus.dispose();
    _prezzoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: 400,
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              children: [
                // TITOLo
                Text(
                  widget.isModifica ? 'Modifica Prodotto' : 'Nuovo Prodotto',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                // UPLOAD IMMAGINE
                GestureDetector(
                  onTap: () {
                    // image picker
                  },
                  child: Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Column(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          color: Color(0xFF6C63FF),
                          size: 36,
                        ),
                        Text(
                          'Carica foto prodotto',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                // CAMPI FORM
                MyTextFormField(
                  titolo: "Nome Prodotto",
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il nome';
                    }
                    return null;
                  },
                ),

                MyTextFormField(
                  titolo: "Descrizione",
                  isTitoloRequired: false,
                  controller: _descrizioneController,
                  focusNode: _descrizioneFocus,
                  validator: (_) => null,
                ),

                MyTextFormField(
                  titolo: "URL",
                  isTitoloRequired: false,
                  controller: _urlController,
                  focusNode: _urlFocus,
                  validator: (_) => null,
                ),

                MyTextFormField(
                  titolo: "Prezzo",
                  isTitoloRequired: false,
                  controller: _prezzoController,
                  focusNode: _prezzoFocus,
                  isNumber: true,
                  isPrice: true,
                  validator: (_) => null,
                ),

                // BOTTONI
                Row(
                  spacing: 24,
                  children: [
                    Expanded(
                      child: MyButton(
                        text: 'Annulla',
                        backTextColor: MyButtonColor.secondaryButton,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: MyButton(
                        text: 'Salva',
                        isLoading: isLoading,
                        onPressed: () async {
                          setState(() => isLoading = true);

                          try {
                            await _validateForm();

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }

                          setState(() => isLoading = false);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _validateForm() async {
    if (!_formKey.currentState!.validate()) return;
    Auth utente = Provider.of<Auth>(context, listen: false);
    final prodotto = Prodotto(
      uid: utente.uid ?? '123',
      idProdotto: widget.prodotto?.idProdotto ?? '',
      nome: _nomeController.text,
      descrizione: _descrizioneController.text,
      immagineUrl: [],
      url: _urlController.text,
      prezzo: _prezzoController.text.isNotEmpty
          ? double.parse(_prezzoController.text.replaceAll(',', '.'))
          : null,
      dataCreazione: widget.prodotto?.dataCreazione ?? DateTime.now(),
      dataUpdate: DateTime.now(),
    );

    try {
      if (widget.isModifica) {
        await Prodotti().updateProdotto(prodotto);
      } else {
        await Prodotti().addProdotto(prodotto);
      }
    } catch (error) {
      throw Exception('Errore durante il salvataggio: $error');
    }

    if (context.mounted) Navigator.of(context).pop();
  }
}
