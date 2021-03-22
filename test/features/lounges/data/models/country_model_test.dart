import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/data/models/country_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/country.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCountryModel =
      CountryModel.fromJson(json.decode(fixture('country.json')));

  test(
    'should be a subclass of CountryModel entity',
    () async {
      // assert
      expect(tCountryModel, isA<Country>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('country.json'));
        // act
        final result = CountryModel.fromJson(jsonMap);
        // assert
        expect(result, tCountryModel);
      },
    );
  });
}
