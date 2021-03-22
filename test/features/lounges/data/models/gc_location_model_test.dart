import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/data/models/gc_location_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/gc_location.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLocationModel =
      GCLocationModel.fromJson(json.decode(fixture('location.json')));

  test(
    'should be a subclass of GCLocation entity',
    () async {
      // assert
      expect(tLocationModel, isA<GCLocation>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('location.json'));
        // act
        final result = GCLocationModel.fromJson(jsonMap);
        // assert
        expect(result, tLocationModel);
      },
    );
  });
}
