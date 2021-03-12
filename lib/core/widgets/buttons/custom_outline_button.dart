import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final String? label;

  final VoidCallback? onPressed;

  final bool? disabled;
  final bool isLoading;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledColor;
  final Color? borderColor;

  final Widget? child;

  const CustomOutlineButton({
    this.onPressed,
    this.label,
    this.disabled = false,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.disabledColor,
    this.borderColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor ?? Theme.of(context).hintColor),
        backgroundColor: backgroundColor,
      ),
      child: child ??
          Text(
            label ?? '',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: textColor ?? null),
          ),
      onPressed: (disabled ?? false)
          ? null
          : isLoading
              ? () {}
              : onPressed,
    );
  }
}
