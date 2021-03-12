import 'package:flutter/material.dart';

class RegisterOptionsButton extends StatelessWidget {
  final IconData? icon;

  final Color? color;
  final Color? iconColor;
  final Color? textColor;

  ///Use when button is an outline button
  final Color? borderColor;

  final String? label;

  final bool isOutline;
  final bool disabled;
  final bool isLoading;

  ///Size must not be null when this field is true
  final bool isCircular;

  ///User when isCircular is true
  final double? size;

  final Function()? onPressed;

  const RegisterOptionsButton({
    this.icon,
    this.color,
    this.iconColor,
    this.label,
    this.textColor,
    this.borderColor,
    this.isOutline = false,
    this.disabled = false,
    this.isLoading = false,
    this.isCircular = false,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCircularButton(context);
  }

  _buildCircularButton(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: color ?? null,
      borderRadius: BorderRadius.circular(30),
      onTap: disabled
          ? null
          : isLoading
              ? () {}
              : onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white30, width: 1),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Theme.of(context).appBarTheme.iconTheme!.color,
        ),
      ),
    );
  }
}
