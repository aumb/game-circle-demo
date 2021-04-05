import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/locale/app_localizations.dart';

enum AddEditReviewPopUpItemsEnum { camera, gallery }

class AddEditReviewPopUpMenu extends StatefulWidget {
  final Function() onGalleryPick;
  final Function() onCameraPick;

  const AddEditReviewPopUpMenu({
    required this.onGalleryPick,
    required this.onCameraPick,
  });

  @override
  _AddEditReviewPopUpMenuState createState() => _AddEditReviewPopUpMenuState();
}

class _AddEditReviewPopUpMenuState extends State<AddEditReviewPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AddEditReviewPopUpItemsEnum>(
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          Icons.camera_alt,
          size: 24,
        ),
      ),
      onSelected: (AddEditReviewPopUpItemsEnum result) {
        if (result == AddEditReviewPopUpItemsEnum.gallery) {
          widget.onGalleryPick();
        } else if (result == AddEditReviewPopUpItemsEnum.camera) {}
      },
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<AddEditReviewPopUpItemsEnum>>[
        PopupMenuItem<AddEditReviewPopUpItemsEnum>(
          value: AddEditReviewPopUpItemsEnum.camera,
          child: Text(Localization.of(context, 'camera')),
        ),
        PopupMenuItem<AddEditReviewPopUpItemsEnum>(
          value: AddEditReviewPopUpItemsEnum.gallery,
          child: Text(Localization.of(context, 'gallery')),
        ),
      ],
    );
  }
}
