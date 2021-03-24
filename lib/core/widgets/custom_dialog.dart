import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final EdgeInsets? insetPadding;
  final EdgeInsets? contentPadding;
  final List<Widget>? content;

  const CustomDialog({
    this.insetPadding,
    this.contentPadding,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
