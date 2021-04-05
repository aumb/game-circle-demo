import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final EdgeInsets? insetPadding;
  final EdgeInsets? contentPadding;
  final List<Widget>? content;
  final Color? backgroundColor;

  const CustomDialog({
    this.insetPadding,
    this.contentPadding,
    this.content,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      insetPadding: insetPadding ??
          EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
      child: Container(
        padding: contentPadding,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: content ?? [],
          ),
        ),
      ),
    );
  }
}
