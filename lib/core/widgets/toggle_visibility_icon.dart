import 'package:flutter/material.dart';

class ToggleVisibilityIcon extends StatelessWidget {
  final bool condition;
  final Function()? onPressedOff;
  final Function()? onPressedOn;

  const ToggleVisibilityIcon({
    Key? key,
    this.condition = false,
    required this.onPressedOff,
    required this.onPressedOn,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return condition
        ? IconButton(
            icon: Icon(
              Icons.visibility_off,
              color: Colors.white30,
            ),
            onPressed: onPressedOff)
        : IconButton(
            icon: Icon(
              Icons.visibility,
              color: Colors.white30,
            ),
            onPressed: onPressedOn,
          );
  }
}
