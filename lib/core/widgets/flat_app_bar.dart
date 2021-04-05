import 'package:flutter/material.dart';

class FlatAppBar extends StatelessWidget with PreferredSizeWidget {
  final Color? backgroundColor;

  const FlatAppBar({
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}
