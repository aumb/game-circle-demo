import 'package:gamecircle/core/entities/gc_image.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/models/gc_image_model.dart';
import 'package:gamecircle/core/models/user_model.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    int? id,
    required int? loungeId,
    required num? rating,
    required String? review,
    List<GCImage?>? images,
    List<int?>? deletedImages,
    User? user,
    DateTime? updatedAt,
    Lounge? lounge,
  }) : super(
          id: id,
          loungeId: loungeId,
          rating: rating,
          user: user,
          review: review,
          images: images,
          deletedImages: deletedImages,
          updatedAt: updatedAt,
          lounge: lounge,
        );

  factory ReviewModel.fromJson(Map<String, dynamic>? json) {
    return ReviewModel(
      id: json?['id'],
      loungeId: json?['lounge_id'],
      rating: json?['rating'],
      review: json?['review'],
      user: UserModel.fromJson(json?['user']),
      images: GCImageModel.fromJsonList(json?['images']),
      updatedAt: DateTime.tryParse(json?['updated_at'] ?? ''),
      lounge: LoungeModel.fromJson(json?['lounge']),
    );
  }

  Map<String, dynamic> toJson() => {
        'lounge_id': loungeId,
        'rating': rating,
        'review': review,
      };

  static List<ReviewModel> fromJsonList(List? json) {
    if (json != null && json.isNotEmpty) {
      List<ReviewModel> reviews =
          json.map((review) => ReviewModel.fromJson(review)).toList();
      return reviews;
    } else {
      return [];
    }
  }
}
