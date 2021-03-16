import 'package:flutter/material.dart';

class FlatAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}
