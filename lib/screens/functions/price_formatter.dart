import 'package:flutter/services.dart';

class RegexConVirgola extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String text = newValue.text;

    // Controlla che il primo carattere non sia 0 a meno che non sia seguito da una virgola per decimali
    if (text.startsWith('0') && text.length > 1 && text[1] != ',') {
      return oldValue;
    }

    // Permette solo numeri con una singola virgola o punto decimale e fino a due decimali
    final RegExp regExp = RegExp(r'^\d*([,\.]?\d{0,2})$');
    if (regExp.hasMatch(text)) {
      // Converte il punto in virgola per uniformare il formato
      final String newText = text.replaceAll('.', ',');
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    return oldValue;
  }
}
