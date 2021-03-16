import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32),
        Container(
          width: double.infinity,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
