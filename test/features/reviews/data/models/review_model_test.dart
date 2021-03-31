import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/gc_image_model.dart';
import 'package:gamecircle/core/models/user_model.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/reviews/data/models/review_model.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tReviewModelFromJson = ReviewModel(
      id: 13,
      rating: 4,
      loungeId: null,
      review: "tessssstt tesssttt tesstttt",
      user: UserModel(id: 1),
      lounge: LoungeModel(
          id: null,
          places: null,
          rating: null,
          reviewCount: null,
          featured: null,
          name: null,
          logoUrl: null,
          phoneNumber: null,
          country: null,
          location: null,
          packages: [],
          timings: [],
          games: [],
          sectionInformation: [],
          features: [],
          distance: null),
      updatedAt: DateTime.tryParse("2021-03-29T11:45:55.000000Z"),
      images: [
        GCImageModel(
            id: 11,
            imageUrl:
                'https://gamecircleinc.s3.eu-west-3.amazonaws.com/review_images/ri-13-1614862977.jpg')
      ]);

  final tReviewModelToJson = ReviewModel(
    loungeId: 1,
    review: "mathiew95@gmail.com",
    rating: 1,
  );

  test(
    'should be a subclass of Review entity',
    () async {
      // assert
      expect(tReviewModelFromJson, isA<Review>());
      expect(tReviewModelToJson, isA<Review>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('review.json'));
        // act
        final result = ReviewModel.fromJson(jsonMap);
        // assert
        expect(result, tReviewModelFromJson);
      },
    );
  });

  // group('toJson', () {
  //   test(
  //     'should return a JSON map containing the proper data',
  //     () async {
  //       // act
  //       final result = tReviewModelFromJson.toJson();
  //       // assert
  //       final expectedMap = {
  //         "id": 1,
  //         "name": "mathiew",
  //         "email": "mathiew95@gmail.com",
  //         "password": "test",
  //         "confirm_password": "test",
  //       };
  //       expect(result, expectedMap);
  //     },
  //   );
  // });
}
