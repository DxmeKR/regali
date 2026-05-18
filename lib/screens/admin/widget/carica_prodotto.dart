import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// MODELS
import '../../../models/prodotto.dart';
// PROVIDER
import '../../../providers/auth.dart';
import '../../../providers/prodotti.dart';
// WIDGET
import '../../../utils/form/my_text_formfield.dart';
import '../../../utils/functions/refactory_image.dart';
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
  final ImagePicker _picker = ImagePicker();
  bool isCamera = false;

  File? _selectedImage;
  bool isLoading = false;

  Future<void> _open() async {
    final XFile? image = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    if (image == null) return;

    final File file = File(image.path);
    final int originalSize = await file.length();
    debugPrint(
      "📸 Original image size: ${(originalSize / 1024).toStringAsFixed(2)} KB",
    );

    final File compressedFile = await compressAndResizeImage(file);
    final int compressedSize = await compressedFile.length();
    debugPrint(
      "📦 Compressed image size: ${(compressedSize / 1024).toStringAsFixed(2)} KB",
    );

    setState(() {
      _selectedImage = compressedFile;
    });
  }

  Future<void> requestPermission(BuildContext context, bool useCamera) async {
    setState(() {
      isCamera = useCamera;
    });
    final permission = useCamera ? Permission.camera : Permission.photos;
    final status = await permission.request();
    if (status.isGranted) {
      await _open();
    } else if (status.isDenied || status.isProvisional) {
      // niente, l'utente ha negato temporaneamente
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        AwesomeDialog(
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          context: context,
          dialogType: DialogType.infoReverse,
          animType: AnimType.scale,
          title: 'Permesso negato',
          desc:
              'Non hai concesso il permesso, vai nelle impostazioni per abilitare l’accesso.',
          btnOkText: "Vai alle impostazioni",
          btnOkColor: Colors.green,
          btnOkOnPress: () {
            openAppSettings();
          },
        ).show();
      }
    }
  }

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
    // Nome
    _nomeController.dispose();
    _nomeFocus.dispose();
    // Descrizione
    _descrizioneController.dispose();
    _descrizioneFocus.dispose();
    // URL
    _urlController.dispose();
    _urlFocus.dispose();
    // Prezzo
    _prezzoController.dispose();
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
          bottom: MediaQuery.of(context).viewInsets.bottom + 48,
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
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return SafeArea(
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Galleria'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    requestPermission(context, false);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Fotocamera'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    requestPermission(context, true);
                                  },
                                ),
                                if (_selectedImage != null ||
                                    (widget.prodotto?.immagineUrl != null &&
                                        widget
                                            .prodotto!
                                            .immagineUrl!
                                            .isNotEmpty))
                                  ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: const Text('Rimuovi immagine'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        _selectedImage = null;
                                        // se edit, rimuoviamo anche l'url esistente solo al salvataggio se necessario
                                        if (widget.isModifica) {}
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
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
                    child: _selectedImage != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedImage = null),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : (widget.prodotto?.immagineUrl != null &&
                              widget.prodotto!.immagineUrl!.isNotEmpty)
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  widget.prodotto!.immagineUrl ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) {
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.white54,
                                        size: 36,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Column(
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
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
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
                            await _validateForm(context);
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _validateForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    Auth utente = Provider.of<Auth>(context, listen: false);

    List<String> immagini = [];

    // se l'utente ha selezionato un'immagine locale, converti in base64 e salva su Firestore
    if (_selectedImage != null) {
      try {
        final dataUri = await encodeImageToBase64(_selectedImage!);
        immagini = [dataUri];
      } catch (e) {
        throw Exception('Errore codifica immagine: $e');
      }
    } else if (widget.isModifica && widget.prodotto?.immagineUrl != null) {
      // mantieni le immagini esistenti se in modifica e non ne è stata scelta una nuova
      immagini = [widget.prodotto!.immagineUrl ?? ''];
    }

    final prodotto = Prodotto(
      uid: utente.uid ?? '',
      idProdotto: widget.prodotto?.idProdotto ?? '',
      nome: _nomeController.text,
      descrizione: _descrizioneController.text,
      immagineUrl: immagini.isNotEmpty ? immagini.first : null,
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
