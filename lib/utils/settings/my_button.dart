import 'package:flutter/material.dart';

//WIDGET
import '../globals.dart';
import './loading.dart';

class MyButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final MyButtonColor backTextColor;
  final bool isLoading;
  final bool hasShape;
  final bool hasFontSmall;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  const MyButton({
    super.key,
    this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.backTextColor = MyButtonColor.defaultColor,
    this.isLoading = false,
    this.hasShape = true,
    this.hasFontSmall = false,
    this.padding,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style:
            ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: hasFontSmall ? 19 : 22,
                vertical: 17,
              ),
              backgroundColor: backTextColor.backgroundColor,
              side: BorderSide(
                color: backTextColor == MyButtonColor.defaultColor
                    ? Colors.black
                    : backTextColor.borderColorHover ??
                          backTextColor.backgroundColor,
                width: 1.3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: hasShape
                    ? const BorderRadius.all(Radius.circular(8))
                    : BorderRadius.zero,
              ),
            ).copyWith(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.disabled)) {
                  return backTextColor.backgroundColor.withValues(alpha: 0.4);
                }
                if (states.contains(WidgetState.hovered) &&
                    backTextColor.backgroundColorHover != null) {
                  return backTextColor.backgroundColorHover;
                }
                return backTextColor.backgroundColor;
              }),
              overlayColor: backTextColor.backgroundColorHover != null
                  ? WidgetStateProperty.all(backTextColor.backgroundColorHover)
                  : null,
              foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey;
                }

                if (states.contains(WidgetState.hovered) &&
                    backTextColor.fontColorHover != null) {
                  return backTextColor.fontColorHover;
                }
                return backTextColor.fontColor;
              }),
            ),
        child: isLoading
            ? const Loading(size: 18)
            : FittedBox(
                fit: icon == null ? BoxFit.scaleDown : BoxFit.none,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ?icon,
                    if (text != null)
                      Text(
                        text!,
                        style: TextStyle(
                          fontSize: hasFontSmall ? 14 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class MyButtonColor {
  final Color backgroundColor;
  final Color fontColor;
  final Color? backgroundColorHover;
  final Color? fontColorHover;
  final Color? borderColorHover;

  const MyButtonColor({
    required this.backgroundColor,
    required this.fontColor,
    this.backgroundColorHover,
    this.fontColorHover,
    this.borderColorHover,
  });

  static const MyButtonColor defaultColor = MyButtonColor(
    backgroundColor: Color(0xFF4CAF50), // Verde decente
    fontColor: Colors.white,
    backgroundColorHover: notSelected,
    fontColorHover: Colors.white,
  );
  static const MyButtonColor secondaryButton = MyButtonColor(
    backgroundColor: onSelectedListTile,
    fontColor: itemSelected,
    backgroundColorHover: notSelected,
    fontColorHover: Colors.white,
  );

  static const MyButtonColor messe = MyButtonColor(
    backgroundColor: Colors.white,
    fontColor: itemSelected,
    backgroundColorHover: itemSelected,
    fontColorHover: Colors.white,
    borderColorHover: itemSelected,
  );
}
