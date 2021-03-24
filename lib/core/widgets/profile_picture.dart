import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';

class ProfilePicture extends StatelessWidget {
  final User? user;
  final double size;

  const ProfilePicture({
    required this.user,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: user?.imageUrl ?? '',
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.5,
            color: CustomColors.white60,
          ),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: CustomColors.backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.5,
            color: CustomColors.white60,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.5,
            color: CustomColors.white60,
          ),
          image: DecorationImage(
            image: AssetImage(Images.logoNoText),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
