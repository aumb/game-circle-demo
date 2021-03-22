import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/data/models/feature_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/feature.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tFeatureModel =
      FeatureModel.fromJson(json.decode(fixture('feature.json')));
  final tFeaturesModel =
      FeatureModel.fromJsonList(json.decode(fixture('features.json')));

  test(
    'should be a subclass of Lounge and List<Lounge> entities',
    () async {
      // assert
      expect(tFeaturesModel, isA<List<Feature>>());
      expect(tFeatureModel, isA<Feature>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid List<Feature> when fromJsonList is called',
      () async {
        // arrange

        // act
        final result =
            FeatureModel.fromJsonList(json.decode(fixture('features.json')));
        expect(result, tFeaturesModel);
      },
    );

    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('feature.json'));
        // act
        final result = FeatureModel.fromJson(jsonMap);
        // assert
        expect(result, tFeatureModel);
      },
    );
  });
}
