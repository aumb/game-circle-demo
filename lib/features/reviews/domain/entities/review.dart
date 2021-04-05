import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/gc_image.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

class Review extends Equatable {
  final int? id;

  ///Used when sending a lounge id to the server
  final int? loungeId;
  final num? rating;
  final String? review;
  final User? user;
  final List<GCImage?>? images;
  final List<int?>? deletedImages;
  final DateTime? updatedAt;
  final Lounge? lounge;

  Review({
    this.id,
    this.loungeId,
    this.rating,
    this.review,
    this.images,
    this.user,
    this.deletedImages,
    this.updatedAt,
    this.lounge,
  });

  @override
  List<Object?> get props => [
        id,
        loungeId,
        rating,
        review,
        images,
        user,
        deletedImages,
        updatedAt,
        lounge,
      ];
}
