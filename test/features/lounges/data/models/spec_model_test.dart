import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/data/models/spec_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/spec.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tSpecModel = SpecModel.fromJson(json.decode(fixture('spec.json')));
  final tSpecsModel =
      SpecModel.fromJsonList(json.decode(fixture('specs.json')));

  test(
    'should be a subclass of Spec and List<Spec> entities',
    () async {
      // assert
      expect(tSpecsModel, isA<List<Spec>>());
      expect(tSpecModel, isA<Spec>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid List<Spec> when fromJsonList is called',
      () async {
        // arrange

        // act
        final result =
            SpecModel.fromJsonList(json.decode(fixture('specs.json')));
        expect(result, tSpecsModel);
      },
    );

    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('spec.json'));
        // act
        final result = SpecModel.fromJson(jsonMap);
        // assert
        expect(result, tSpecModel);
      },
    );
  });
}
