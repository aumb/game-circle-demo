import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:gamecircle/core/entities/gc_image.dart';
import 'package:gamecircle/core/managers/navgiation_manager.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';
import 'package:gamecircle/features/lounge/presentation/widgets/lounge_image_preview.dart';
import 'package:gamecircle/injection_container.dart';

class LoungePicturesCarousel extends StatelessWidget {
  final List<GCImage?>? images;

  const LoungePicturesCarousel({
    this.images,
  });

  @override
  Widget build(BuildContext context) {
    return (images != null && images!.isNotEmpty)
        ? CarouselSlider.builder(
            options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 1,
              disableCenter: true,
              reverse: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
            itemCount: images?.length ?? 0,
            itemBuilder: (context, index, realIndex) => CachedNetworkImage(
              imageUrl: images?[index]?.imageUrl ?? '',
              imageBuilder: (context, imageProvider) =>
                  _buildImage(imageProvider, index, context),
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  color: CustomColors.cardColor,
                ),
              ),
              errorWidget: (context, url, error) =>
                  _buildImage(AssetImage(Images.logoNoText), index, context),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: CustomColors.cardColor,
              image: DecorationImage(
                image: AssetImage(Images.logoNoText),
                fit: BoxFit.cover,
              ),
            ),
          );
  }

  InkWell _buildImage(
      ImageProvider<Object> image, int index, BuildContext context) {
    return InkWell(
      onTap: () => onImageTap(context, index),
      child: Hero(
        tag: images![index]!.id!.toString() + images![index]!.imageUrl!,
        child: Container(
          decoration: BoxDecoration(
            color: CustomColors.cardColor,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: image,
            ),
          ),
        ),
      ),
    );
  }

  void onImageTap(BuildContext context, int index) {
    sl<NavigationManager>().navigateTo(
      LoungeImagePreview(
        images: images,
        selectedImageIndex: index,
      ),
    );
  }
}
