import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/prodotto.dart';
import '../../../models/utente.dart';
import '../../../providers/prodotti.dart';
import '../../../utils/globals.dart';
import '../../../utils/settings/my_button.dart';
import '../../../utils/settings/my_text_formfield.dart';

class CaricaProdotto extends StatefulWidget {
  const CaricaProdotto({super.key});

  @override
  State<CaricaProdotto> createState() => _CaricaProdottoState();
}

class _CaricaProdottoState extends State<CaricaProdotto> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descrizioneController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _prezzoController = TextEditingController();
  FocusNode _nomeFocus = FocusNode();
  FocusNode _descrizioneFocus = FocusNode();
  FocusNode _urlFocus = FocusNode();
  FocusNode _prezzoFocus = FocusNode();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _descrizioneController = TextEditingController();
    _urlController = TextEditingController();
    _prezzoController = TextEditingController();
    _nomeFocus = FocusNode();
    _descrizioneFocus = FocusNode();
    _urlFocus = FocusNode();
    _prezzoFocus = FocusNode();
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
    Prodotti prodotti = Provider.of<Prodotti>(context, listen: false);
    Utente utente = Provider.of<Utente>(context, listen: false);
    return AlertDialog(
      backgroundColor: Colors.white24,
      buttonPadding: EdgeInsets.zero,
      title: Text(
        'Carica Prodotto',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall!.copyWith(color: itemSelected),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextFormField(
              titolo: "Nome Prodotto",
              controller: _nomeController,
              focusNode: _nomeFocus,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Inserisci il nome del prodotto';
                }
                return null;
              },
            ),
            MyTextFormField(
              isTitoloRequired: false,
              titolo: "Descrizione Prodotto",
              controller: _descrizioneController,
              focusNode: _descrizioneFocus,
              validator: (value) {
                return null;
              },
            ),
            MyTextFormField(
              titolo: "URL Prodotto",
              isTitoloRequired: false,
              controller: _urlController,
              focusNode: _urlFocus,
              validator: (value) {
                return null;
              },
            ),
            MyTextFormField(
              titolo: "Prezzo Prodotto",
              isTitoloRequired: false,
              controller: _prezzoController,
              focusNode: _prezzoFocus,
              isNumber: true,
              isPrice: true,
              validator: (value) {
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            spacing: 16,
            children: [
              Flexible(
                child: MyButton(
                  margin: EdgeInsetsDirectional.zero,
                  text: 'Annulla',
                  backTextColor: MyButtonColor.secondaryButton,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Flexible(
                child: MyButton(
                  margin: EdgeInsetsDirectional.zero,
                  text: 'Conferma',
                  isLoading: isLoading,
                  onPressed: () async {
                    setState(() => isLoading = true);
                    try {
                      await _validateForm(prodotti, utente.idUtente, context);
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        );
                      }
                    }
                    setState(() => isLoading = false);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _validateForm(
    Prodotti prodotti,
    String idUtente,
    BuildContext context,
  ) async {
    if (_formKey.currentState!.validate()) {
      /*   if (messaPrenotata != null) {
        // Modifica prenotazione esistente
        Messa modificaMessa = Messa(
          idMessa: messaPrenotata.idMessa,
          idConvento: idConvento,
          dataPrenotata: DateFormat(
            patternDateTime,
          ).parse(_dataPrenotataController.text),
          intento: _intentoController.text,
          offerta: double.parse(_offertaController.text.replaceAll(',', '.')),
          notaAggiuntiva: _notaAggiuntivaController.text,
        );

        try {
          await messePrenotate.updatePrenotazione(modificaMessa);
        } catch (error) {
          throw Exception("Errore durante la modifica: ${error.toString()}");
        }
      } else { */
      // Nuova prenotazione
      Prodotto nuovoProdotto = Prodotto(
        uid: idUtente,
        idProdotto: '',
        nome: _nomeController.text,
        descrizione: _descrizioneController.text,
        prezzo: double.parse(_prezzoController.text.replaceAll(',', '.')),
      );
      try {
        await prodotti.addProdotto(nuovoProdotto);
      } catch (error) {
        throw Exception("Errore durante la prenotazione: ${error.toString()}");
      }
      // }
    }
  }
}
