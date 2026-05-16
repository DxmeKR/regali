import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//UTIL
import '../globals.dart';
import './my_input_decoration.dart';
import 'my_form_titolo.dart';
//WIDGET
// import './my_form_titolo.dart';

class MyTextFormField extends StatefulWidget {
  final String? titolo;
  final bool isTitoloRequired;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final String helperText;
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
  final bool isRectangular;
  final double? width;
  final bool hasSuffix;
  final IconData? suffixIcon;
  final int maxLength;
  final int maxLines;
  final List<String>? autofillHints;
  final double bottomMargin;
  final double rightMargin;
  final bool enabled;
  final bool isPrenotazione;
  const MyTextFormField({
    this.titolo,
    this.isTitoloRequired = true,
    required this.controller,
    required this.focusNode,
    this.hintText = "",
    this.helperText = "",
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
    this.isRectangular = false,
    this.hasSuffix = false,
    this.suffixIcon,
    this.width = double.infinity,
    this.maxLength = 50,
    this.maxLines = 1,
    this.autofillHints,
    this.bottomMargin = 20,
    this.rightMargin = 0,
    this.enabled = true,
    this.isPrenotazione = false,
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
          margin: EdgeInsets.only(
            bottom: widget.bottomMargin,
            right: widget.rightMargin,
          ),
          child: TextFormField(
            onTapOutside: (event) => widget.focusNode.unfocus(),
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            autofillHints: widget.autofillHints,
            inputFormatters: [
              if (widget.isNumber) FilteringTextInputFormatter.digitsOnly,
              if (widget.isLettersOnly)
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
              if (widget.isLettersOnlywithSpace)
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              if (widget.isUpperCase) UpperCaseTextFormatter(),
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
            onTap: widget.isDate
                ? () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.isPrenotazione
                          ? null
                          : DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: widget.isPrenotazione
                          ? DateTime(3000)
                          : DateTime.now(),
                      locale: const Locale('it', 'IT'),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              //bg color
                              surface: Colors.grey,
                              // Colore del testo in generale
                              onSurface: itemSelected,
                              // Colore del num selezionato
                              onPrimary: Colors.white,
                              // Colore del cerchio di selezione
                              primary: itemSelected,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                // Colore dei pulsanti "OK" e "CANCEL"
                                foregroundColor: itemSelected,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      // mostra il TimePicker subito dopo la selezione della data
                      TimeOfDay? pickedTime;
                      if (context.mounted) {
                        pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.input,

                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  surface: Colors.grey,
                                  onSurface: itemSelected,
                                  onPrimary: Colors.white,
                                  primary: itemSelected,
                                ),
                              ),
                              child: MediaQuery(
                                data: MediaQuery.of(
                                  context,
                                ).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              ),
                            );
                          },
                        );
                      }

                      final DateTime combined = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime?.hour ?? 0,
                        pickedTime?.minute ?? 0,
                      );

                      setState(() {
                        widget.controller.text = DateFormat(
                          "MMM dd yyyy - HH:mm",
                        ).format(combined);
                      });
                    }
                  }
                : null,
            keyboardType: widget.maxLines > 1
                ? TextInputType.multiline
                : widget.keyboardType,
            obscureText: _obscureText,
            decoration:
                myInputDecoration(
                  hintText: widget.hintText,
                  helperText: widget.helperText,
                  isRectangular: widget.isRectangular,
                  suffix: widget.hasSuffix
                      ? "${widget.controller.text.length.toString()}/${widget.maxLength}"
                      : null,
                ).copyWith(
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
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
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                          ),
                        )
                      : widget.suffixIcon != null
                      ? Icon(widget.suffixIcon)
                      : null,
                ),
            validator: widget.validator,
            onFieldSubmitted: widget.onFieldSubmitted,
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
