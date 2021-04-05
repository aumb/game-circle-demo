import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';
import 'package:gamecircle/core/utils/string_utils.dart';

class AddEditReviewImage extends StatefulWidget {
  final File? fileImage;
  final String? urlImage;
  final Function() onDeleteImage;
  final Function() onImageTap;

  const AddEditReviewImage({
    this.fileImage,
    this.urlImage,
    required this.onImageTap,
    required this.onDeleteImage,
  });

  @override
  _AddEditReviewImageState createState() => _AddEditReviewImageState();
}

class _AddEditReviewImageState extends State<AddEditReviewImage> {
  bool isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return StringUtils().isNotEmpty(widget.urlImage)
        ? _buildNetworkImage()
        : _buildImage();
  }

  CachedNetworkImage _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: widget.urlImage ?? '',
      imageBuilder: (context, imageProvider) => _buildStack(imageProvider),
      placeholder: (context, url) => Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: CustomColors.cardColor,
        ),
      ),
      errorWidget: (context, url, error) =>
          _buildStack(AssetImage(Images.logoNoText)),
    );
  }

  Stack _buildImage() {
    final image = FileImage(widget.fileImage!);
    return _buildStack(image);
  }

  Stack _buildStack(ImageProvider<Object> image) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsetsDirectional.only(end: 12),
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: image,
            ),
          ),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: isDeleting ? 0.7 : 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).errorColor,
              ),
              width: 130,
              height: 130,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsetsDirectional.only(end: 12),
              child: InkWell(
                onTap: isDeleting
                    ? () {
                        widget.onDeleteImage();
                        isDeleting = false;
                      }
                    : widget.onImageTap,
                onLongPress: () {
                  isDeleting = !isDeleting;
                  if (mounted) setState(() {});
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
