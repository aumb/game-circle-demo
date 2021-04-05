import 'package:flutter/material.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/core/utils/custom_colors.dart';
import 'package:gamecircle/core/utils/gc_date_utils.dart';
import 'package:gamecircle/core/widgets/custom_divider.dart';
import 'package:gamecircle/core/widgets/profile_picture.dart';
import 'package:gamecircle/core/widgets/read_more_widget.dart';
import 'package:gamecircle/core/widgets/star_rating.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/presentation/widgets/reivew_image.dart';
import 'package:gamecircle/features/reviews/presentation/widgets/review_image_preview.dart';
import 'package:gamecircle/injection_container.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final Function()? onEdit;

  ReviewCard({
    required this.review,
    this.onEdit,
  });

  bool get isReviewer => review.user?.id == sl<SessionManager>().user?.id;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfilePicture(
              imageUrl:
                  isReviewer ? review.lounge?.logoUrl : review.user?.imageUrl,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _getName(),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 4),
                Text(
                  GCDateUtils().getStrDate((review.updatedAt ?? DateTime.now()),
                      pattern: 'd MMMM y hh:mm a'),
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
            if (isReviewer)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: CustomColors.secondaryAccent,
                        size: 20,
                      ),
                      onPressed: onEdit,
                    )
                  ],
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: <Widget>[
              StarRating(
                rating: review.rating?.toDouble() ?? 0,
                starSize: 16,
              ),
              SizedBox(
                width: 4,
              ),
              Text(review.rating.toString(),
                  style: Theme.of(context).textTheme.bodyText2),
            ],
          ),
        ),
        ReadMoreWidget(
          review.review ?? '',
          colorClickableText: Theme.of(context).accentColor,
          trimLines: 4,
          trimMode: TrimMode.Line,
          trimCollapsedText: '...read more',
          trimExpandedText: 'read less',
        ),
        if (review.images != null && review.images!.isNotEmpty)
          SizedBox(height: 12),
        if (review.images != null && review.images!.isNotEmpty)
          _buildImages(context),
        SizedBox(height: 12),
        CustomDivider(),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildImages(BuildContext context) {
    List<Widget> imagesWidget = [];
    for (int i = 0; i < review.images!.length; i++) {
      imagesWidget.add(
        ReviewImage(
          urlImage: review.images![i]!.imageUrl!,
          onImageTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReviewImagePreview(
                  selectedImageIndex: i,
                  images: review.images,
                ),
              ),
            );
          },
        ),
      );
      imagesWidget.add(
        SizedBox(
          width: 12,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: imagesWidget,
          ),
        ),
      ],
    );
  }

  String _getName() {
    String _userName = review.user?.name ?? '';
    String _loungeName = review.lounge?.name ?? '';
    if (isReviewer) {
      return _loungeName;
    }
    return _userName;
  }
}
