import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/data/models/timing_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/timing.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tTimingModel =
      TimingModel.fromJson(json.decode(fixture('timing.json')));
  final tTimingsModel =
      TimingModel.fromJsonList(json.decode(fixture('timings.json')));

  test(
    'should be a subclass of Timing and List<Timing> entities',
    () async {
      // assert
      expect(tTimingsModel, isA<List<Timing>>());
      expect(tTimingModel, isA<Timing>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid List<Timing> when fromJsonList is called',
      () async {
        // arrange

        // act
        final result =
            TimingModel.fromJsonList(json.decode(fixture('timings.json')));
        expect(result, tTimingsModel);
      },
    );

    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('timing.json'));
        // act
        final result = TimingModel.fromJson(jsonMap);
        // assert
        expect(result, tTimingModel);
      },
    );
  });
}
