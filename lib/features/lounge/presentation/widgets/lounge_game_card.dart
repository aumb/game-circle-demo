import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';

class GameCard extends StatelessWidget {
  final String imgUrl;
  final Function() onTap;
  final int? index;

  const GameCard({
    required this.imgUrl,
    required this.onTap,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: (index != null) && index == 3 ? 0.2 : 1,
              child: _buildPicture(),
            ),
            (index != null && index == 3)
                ? Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.search,
                      size: 48,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildPicture() {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
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
        decoration: BoxDecoration(
          color: CustomColors.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            width: 0.5,
            color: CustomColors.white60,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          color: CustomColors.cardColor,
          borderRadius: BorderRadius.circular(14),
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
