import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
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
  // File? _selectedImage;
  Uint8List? _imageBytes;
  bool _removeExistingImage = false;
  bool _isChecked = false;
  bool isLoading = false;
  bool _isDeleting = false;

  Future<void> _open() async {
    final XFile? image = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      _imageBytes = bytes;
      _removeExistingImage = true;
    });
  }

  // Future<void> _open() async {

  //     final XFile? image = await _picker.pickImage(
  //       source: isCamera ? ImageSource.camera : ImageSource.gallery,
  //       imageQuality: 85,
  //       maxWidth: 1600,
  //       maxHeight: 1600,
  //     );
  //     if (image == null) return;

  //     final File file = File(image.path);
  //     final File compressedFile = await compressAndResizeImage(file);

  //     setState(() {
  //       _selectedImage = compressedFile;
  //       _removeExistingImage =
  //           true; // se scelgo una nuova immagine, rimuovo l'url esistente alla salva
  //     });

  // }

  Future<void> requestPermission(BuildContext context, bool useCamera) async {
    setState(() {
      isCamera = useCamera;
    });

    // 🔥 WEB: salta permessi
    if (kIsWeb) {
      await _open();
      return;
    }

    final permission = useCamera ? Permission.camera : Permission.photos;
    final status = await permission.request();

    if (status.isGranted) {
      await _open();
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.infoReverse,
          title: 'Permesso negato',
          desc: 'Vai nelle impostazioni per abilitarlo',
          btnOkOnPress: () => openAppSettings(),
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
      _isChecked = widget.prodotto!.isChecked;
      // non forziamo il download della rete; gestiamo la visualizzazione nel build
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _nomeFocus.dispose();
    _descrizioneController.dispose();
    _descrizioneFocus.dispose();
    _urlController.dispose();
    _urlFocus.dispose();
    _prezzoController.dispose();
    _prezzoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        color: Colors.white,
        width: 400,
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isModifica
                            ? 'Modifica Prodotto'
                            : 'Nuovo Prodotto',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.isModifica)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: _isDeleting
                              ? const SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : IconButton(
                                  tooltip: 'Elimina prodotto',
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Elimina prodotto'),
                                        content: const Text(
                                          'Sei sicuro di voler eliminare definitivamente questo prodotto?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(false),
                                            child: const Text('Annulla'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                            ),
                                            child: const Text('Elimina'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm != true) return;

                                    setState(() => _isDeleting = true);
                                    try {
                                      await Prodotti().deleteProdotto(
                                        widget.prodotto!,
                                      );
                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Prodotto eliminato'),
                                        ),
                                      );
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Errore eliminazione: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (context.mounted) {
                                        setState(() => _isDeleting = false);
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                        ),
                    ],
                  ),

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
                                  if (_imageBytes != null ||
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
                                          _imageBytes = null;
                                          _removeExistingImage = true;
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
                      child: _buildImagePreview(),
                    ),
                  ),

                  MyTextFormField(
                    bottomMargin: 0,
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
                    bottomMargin: 0,
                    maxLines: 4,
                    maxLength: 200,
                    titolo: "Descrizione",
                    isTitoloRequired: false,
                    controller: _descrizioneController,
                    focusNode: _descrizioneFocus,
                    validator: (_) => null,
                  ),

                  MyTextFormField(
                    bottomMargin: 0,
                    titolo: "URL",
                    isTitoloRequired: false,
                    controller: _urlController,
                    focusNode: _urlFocus,
                    validator: (_) => null,
                  ),

                  MyTextFormField(
                    bottomMargin: 0,
                    titolo: "Prezzo",
                    isTitoloRequired: false,
                    controller: _prezzoController,
                    focusNode: _prezzoFocus,
                    isNumber: true,
                    isPrice: true,
                    validator: (_) => null,
                  ),

                  if (widget.isModifica) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Segnato come non disponibile',
                          style: TextStyle(fontSize: 14),
                        ),
                        const Spacer(),
                        Switch(
                          value: _isChecked,
                          onChanged: (v) => setState(() => _isChecked = v),
                        ),
                      ],
                    ),
                  ],

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
      ),
    );
  }

  Widget _buildImagePreview() {
    // Priorità: immagine selezionata locale -> immagine esistente (se non marcata per rimozione) -> placeholder
    if (_imageBytes != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(_imageBytes!, fit: BoxFit.cover),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => setState(() {
                _imageBytes = null;
                _removeExistingImage = true;
              }),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final src = widget.prodotto?.immagineUrl ?? '';
    if (src.isNotEmpty && !_removeExistingImage) {
      // support data URI (base64) o url
      if (src.startsWith('data:')) {
        final base64Str = src.split(',').length > 1 ? src.split(',')[1] : src;
        final bytes = base64Decode(base64Str);
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => setState(() => _removeExistingImage = true),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ],
        );
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(src, fit: BoxFit.cover),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => setState(() => _removeExistingImage = true),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, color: Color(0xFF6C63FF), size: 36),
        Text(
          'Carica foto prodotto',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Future<void> _validateForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final Auth utente = Provider.of<Auth>(context, listen: false);

    List<String> immagini = [];

    // 1. nuova immagine (priorità massima)
    if (_imageBytes != null) {
      final dataUri = 'data:image/png;base64,${base64Encode(_imageBytes!)}';
      immagini = [dataUri];
    }
    // 2. rimozione immagine
    else if (_removeExistingImage) {
      immagini = [];
    }
    // 3. immagine già esistente (solo se NON rimossa)
    else if (widget.isModifica &&
        widget.prodotto?.immagineUrl != null &&
        widget.prodotto!.immagineUrl!.isNotEmpty) {
      immagini = [widget.prodotto!.immagineUrl!];
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
      isChecked: _isChecked,
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
