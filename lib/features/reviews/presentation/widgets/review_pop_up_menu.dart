import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';

enum ReviewPopUpItemsEnum { edit, delete }

class ReviewPopUpMenu extends StatefulWidget {
  @override
  _ReviewPopUpMenuState createState() => _ReviewPopUpMenuState();
}

class _ReviewPopUpMenuState extends State<ReviewPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ReviewPopUpItemsEnum>(
      icon: Icon(Icons.more_vert),
      onSelected: (ReviewPopUpItemsEnum result) {
        setState(() {
          print("test");
        });
      },
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<ReviewPopUpItemsEnum>>[
        PopupMenuItem<ReviewPopUpItemsEnum>(
          value: ReviewPopUpItemsEnum.edit,
          child: Text(Localization.of(context, 'edit')),
        ),
        PopupMenuItem<ReviewPopUpItemsEnum>(
          value: ReviewPopUpItemsEnum.delete,
          child: Text(Localization.of(context, 'delete')),
        ),
      ],
    );
  }
}
