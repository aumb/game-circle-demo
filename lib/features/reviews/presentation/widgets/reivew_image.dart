import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';

class ReviewImage extends StatefulWidget {
  final String? urlImage;
  final Function()? onImageTap;

  const ReviewImage({
    this.urlImage,
    this.onImageTap,
  });

  @override
  _ReviewImageState createState() => _ReviewImageState();
}

class _ReviewImageState extends State<ReviewImage> {
  @override
  Widget build(BuildContext context) {
    return _buildNetworkImage();
  }

  CachedNetworkImage _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: widget.urlImage ?? '',
      imageBuilder: (context, imageProvider) => _buildImage(imageProvider),
      placeholder: (context, url) => Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: CustomColors.cardColor,
        ),
      ),
      errorWidget: (context, url, error) =>
          _buildImage(AssetImage(Images.logoNoText)),
    );
  }

  InkWell _buildImage(ImageProvider<Object> image) {
    return InkWell(
      onTap: widget.onImageTap,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: image,
          ),
        ),
      ),
    );
  }
}
