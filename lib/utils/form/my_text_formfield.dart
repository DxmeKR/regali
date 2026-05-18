import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//SETTING
import '../globals.dart';
import './price_formatter.dart';
import './my_input_decoration.dart';

//WIDGET
import './my_form_titolo.dart';

class MyTextFormField extends StatefulWidget {
  final String? titolo;
  final bool isTitoloRequired;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hintText;
  final String? helperText;
  final String? Function(String?) validator;
  final void Function(String)? onFieldSubmitted;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool isDate;
  final bool isNumber;
  final bool isLettersOnly;
  final bool isLettersOnlywithSpace;
  final bool isUpperCase;
  final bool isPrice;
  final double height;
  final double? width;
  final bool hasSuffix;
  final IconData? suffixIcon;
  final int maxLength;
  final int maxLines;
  final List<String>? autofillHints;
  final double bottomMargin;
  final double rightMargin;
  final bool enabled;
  final bool isNumberWithDecimal;
  const MyTextFormField({
    this.titolo,
    this.isTitoloRequired = true,
    required this.controller,
    required this.focusNode,
    this.hintText,
    this.helperText,
    required this.validator,
    this.onFieldSubmitted,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.isDate = false,
    this.isNumber = false,
    this.isLettersOnly = false,
    this.isLettersOnlywithSpace = false,
    this.isUpperCase = false,
    this.isPrice = false,
    this.hasSuffix = false,
    this.suffixIcon,
    this.height = 70,
    this.width = double.infinity,
    this.maxLength = 50,
    this.maxLines = 1,
    this.autofillHints,
    this.bottomMargin = 20,
    this.rightMargin = 0,
    this.enabled = true,
    this.isNumberWithDecimal = false,
    super.key,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;

    if (widget.hasSuffix) {
      widget.controller.addListener(() {
        setState(() {
          widget.controller.text.length;
        });
      });
    }

    if (widget.isPrice) {
      widget.focusNode.addListener(() {
        if (!widget.focusNode.hasFocus) {
          _formatPrice();
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.isPrice) {
      widget.focusNode.removeListener(_formatPrice);
    }

    super.dispose();
  }

  void _formatPrice() {
    final String text = widget.controller.text.replaceAll(',', '.');
    double? value = double.tryParse(text);

    if (value != null) {
      setState(() {
        widget.controller.text = value.toStringAsFixed(2).replaceAll('.', ',');
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );
      });
    }
  }

  final RegExp strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~.,;:\-_])[A-Za-z\d!@#\$&*~.,;:\-_]{8,}$',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //titolo
        if (widget.titolo != null)
          MyFormTitolo(
            titolo: widget.titolo!,
            isRequired: widget.isTitoloRequired,
          ),

        //textformfield
        Container(
          width: widget.width,
          height: widget.isTitoloRequired ? 70 : widget.height,
          margin: EdgeInsets.only(right: widget.rightMargin),
          child: TextFormField(
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            autofillHints: widget.autofillHints,
            inputFormatters: [
              if (widget.isNumberWithDecimal)
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              if (widget.isNumber) FilteringTextInputFormatter.digitsOnly,
              if (widget.isLettersOnly)
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
              if (widget.isLettersOnlywithSpace)
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              if (widget.isUpperCase) UpperCaseTextFormatter(),
              if (widget.isPrice) RegexConVirgola(),
              LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            controller: widget.controller,
            cursorColor: Colors.black45,
            maxLines: widget.maxLines,
            textInputAction: widget.maxLines > 1
                ? TextInputAction.newline
                : TextInputAction.done,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: textHeavyBlack),
            readOnly: widget.isDate ? true : false,
            keyboardType: widget.maxLines > 1
                ? TextInputType.multiline
                : widget.keyboardType,
            obscureText: _obscureText,
            decoration:
                myInputDecoration(
                  hintText: widget.hintText,
                  helperText: widget.helperText,
                  suffix: widget.hasSuffix
                      ? "${widget.controller.text.length.toString()}/${widget.maxLength}"
                      : null,
                ).copyWith(
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            !_obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        )
                      : widget.isDate
                      ? const Icon(Icons.calendar_today_outlined)
                      : widget.suffixIcon != null
                      ? Icon(widget.suffixIcon)
                      : null,
                ),
            validator: widget.validator,
            onFieldSubmitted: widget.onFieldSubmitted,
            // onTap: widget.isDate
            // ? () async {
            //     DateTime? pickedDate = await showDatePicker(
            //       keyboardType: const TextInputType.numberWithOptions(
            //         decimal: false,
            //         signed: false,
            //       ),
            //       context: context,
            //       firstDate: DateTime(1900),
            //       lastDate: DateTime.now(),
            //       // locale: const Locale('it', 'IT'),
            //       builder: (BuildContext context, Widget? child) {
            //         return Theme(
            //           data: ThemeData.light().copyWith(
            //             colorScheme: const ColorScheme.light(
            //               //bg color
            //               surface: Color(0xffE2F3D2),
            //               // Colore del testo in generale
            //               onSurface: Color(0xff1D1B20),
            //               // Colore del num selezionato
            //               onPrimary: Colors.white,
            //               // Colore del cerchio di selezione
            //               primary: Color(0xff59763D),
            //             ),
            //             textButtonTheme: TextButtonThemeData(
            //               style: TextButton.styleFrom(
            //                 // Colore dei pulsanti "OK" e "CANCEL"
            //                 foregroundColor: const Color(0xff59763D),
            //               ),
            //             ),
            //           ),
            //           child: child!,
            //         );
            //       },
            //     );

            // if (pickedDate != null) {
            //   setState(() {
            //     widget.controller.text = DateFormat(patternDate).format(
            //       DateTime(
            //         pickedDate.year,
            //         pickedDate.month,
            //         pickedDate.day,
            //       ),
            //     );
            //   });
            // }
            //   }
            // : null,
          ),
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
