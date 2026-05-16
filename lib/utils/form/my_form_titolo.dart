import 'package:flutter/material.dart';

//SETTING
import '../globals.dart';

class MyFormTitolo extends StatelessWidget {
  final String titolo;
  final bool isRequired;
  const MyFormTitolo({required this.titolo, this.isRequired = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: bgBlack,
          ),
          children: [
            TextSpan(text: '$titolo '),
            if (isRequired)
              WidgetSpan(
                alignment: PlaceholderAlignment.top,
                child: Tooltip(
                  message: 'Campo obbligatorio',
                  child: Text(
                    '*',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
