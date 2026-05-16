import 'package:flutter/material.dart';

class MyFormTitolo extends StatelessWidget {
  final String titolo;
  final bool isRequired;
  const MyFormTitolo({required this.titolo, this.isRequired = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black,
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
