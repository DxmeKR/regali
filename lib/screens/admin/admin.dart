import 'package:flutter/material.dart';
import 'package:regali/utils/settings/my_scaffold.dart';

import '../../utils/widget/my_showdialog.dart';
import 'widget/carica_prodotto.dart';

class GiftCmsPage extends StatefulWidget {
  static const String routeName = '/admin/home';
  const GiftCmsPage({super.key});

  @override
  State<GiftCmsPage> createState() => _GiftCmsPageState();
}

class _GiftCmsPageState extends State<GiftCmsPage> {
  // Dati fake di esempio (placeholder) che poi sostituirai con il tuo StreamBuilder di Firebase
  final List<Map<String, dynamic>> _dummyGifts = [
    {
      'title': 'PlayStation 5 Pro',
      'price': '799.00',
      'description': 'Edizione con lettore disco, per il salotto.',
      'imageUrl': null, // null simula la mancanza di immagine o placeholder
    },
    {
      'title': 'Tastiera Meccanica NuPhy',
      'price': '140.00',
      'description': 'Layout 75%, switch low profile.",',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Tema dark/moderno personalizzato per darti un'idea di palette colori
    return MyScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con riepilogo e bottone di aggiunta veloce
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'I tuoi Regali',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_dummyGifts.length} elementi in lista',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => CreateUpdateProdotto.show(context),
                  // onPressed: () => _showGiftFormBottomSheet(context),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Aggiungi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Lista dei regali (nel tuo caso qui metterai lo StreamBuilder)
            Expanded(
              child: ListView.builder(
                itemCount: _dummyGifts.length,
                itemBuilder: (context, index) {
                  final gift = _dummyGifts[index];
                  return _buildGiftCard(gift);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget per la singola card del regalo nella lista del CMS
  Widget _buildGiftCard(Map<String, dynamic> gift) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Immagine o Placeholder grafico
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                image: gift['imageUrl'] != null
                    ? DecorationImage(
                        image: NetworkImage(gift['imageUrl']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: gift['imageUrl'] == null
                  ? const Icon(
                      Icons.card_giftcard,
                      color: Color(0xFF6C63FF),
                      size: 32,
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Dettagli Testo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gift['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '€ ${gift['price']}',
                    style: const TextStyle(
                      color: Color(0xFFFFB703),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gift['description'],
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Azioni: Modifica ed Elimina
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.blueAccent,
                    size: 22,
                  ),
                  onPressed: () =>
                      _showGiftFormBottomSheet(context, gift: gift),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                  onPressed: () {
                    // Logica per eliminare il documento da Firestore
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Pannello Bottom Sheet per inserire o modificare un regalo (UI del Form)
  void _showGiftFormBottomSheet(
    BuildContext context, {
    Map<String, dynamic>? gift,
  }) {
    final isEditing = gift != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permette al pannello di salire quando compare la tastiera
      backgroundColor: const Color(0xFF1E1E24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                24, // Padding dinamico per tastiera
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Modifica Regalo' : 'Nuovo Regalo',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Zona Caricamento Immagine / Anteprima
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Qui userai il pacchetto image_picker per caricare su Firebase Storage
                    },
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF6C63FF).withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: Color(0xFF6C63FF),
                            size: 36,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Carica foto regalo',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo Nome
                TextFormField(
                  initialValue: isEditing ? gift['title'] : '',
                  decoration: _inputDecoration(
                    'Nome del regalo',
                    Icons.card_giftcard,
                  ),
                ),
                const SizedBox(height: 16),

                // Campo Prezzo
                TextFormField(
                  initialValue: isEditing ? gift['price'] : '',
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Prezzo (€)', Icons.euro),
                ),
                const SizedBox(height: 16),

                // Campo Descrizione
                TextFormField(
                  initialValue: isEditing ? gift['description'] : '',
                  maxLines: 3,
                  decoration: _inputDecoration(
                    'Note / Descrizione',
                    Icons.description_outlined,
                  ),
                ),
                const SizedBox(height: 24),

                // Bottone di Conferma Salva/Aggiorna
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logica di invio dati a Firestore (set o add)
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Salva Modifiche' : 'Inserisci nella Lista',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper per mantenere pulito lo stile degli input text
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
      labelStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.grey[900],
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[800]!),
      ),
    );
  }
}
