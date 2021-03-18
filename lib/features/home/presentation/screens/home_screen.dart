import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Localization.of(context, 'first_string'),
        ),
      ),
    );
  }
}
