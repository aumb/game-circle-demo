import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:gamecircle/core/entities/gc_image.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/images.dart';

class LoungePicturesCarousel extends StatelessWidget {
  final List<GCImage?>? images;
  const LoungePicturesCarousel({this.images});
  @override
  Widget build(BuildContext context) {
    return (images != null && images!.isNotEmpty)
        ? CarouselSlider.builder(
            options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 1,
              disableCenter: true,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
            itemCount: images?.length ?? 0,
            itemBuilder: (context, index, realIndex) => CachedNetworkImage(
              imageUrl: images?[index]?.imageUrl ?? '',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  color: CustomColors.cardColor,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  color: CustomColors.cardColor,
                  image: DecorationImage(
                    image: AssetImage(Images.logoNoText),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
}
