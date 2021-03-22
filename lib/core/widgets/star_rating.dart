import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  late final int starCount;
  late final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  late final MainAxisAlignment row;
  late final double starSize;
  late final bool isLoading;

  StarRating({
    this.starCount = 5,
    this.rating = .0,
    this.onRatingChanged,
    this.color,
    this.row = MainAxisAlignment.start,
    this.starSize = 16.0,
    this.isLoading = false,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        size: starSize,
        color: color ?? Theme.of(context).textTheme.headline6!.color,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(Icons.star_half,
          size: starSize, color: color ?? Theme.of(context).accentColor);
    } else {
      icon = Icon(
        Icons.star,
        size: starSize,
        color: color ?? Theme.of(context).accentColor,
      );
    }
    return InkResponse(
      onTap: isLoading
          ? null
          : onRatingChanged == null
              ? null
              : () => onRatingChanged!(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: row,
        children: List.generate(
          starCount,
          (index) => buildStar(context, index),
        ),
      ),
    );
  }
}
