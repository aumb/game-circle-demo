import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/data/models/package_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/package.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tPackageModel =
      PackageModel.fromJson(json.decode(fixture('gcpackage.json')));
  final tPackagesModel =
      PackageModel.fromJsonList(json.decode(fixture('gcpackages.json')));

  test(
    'should be a subclass of Package and List<Package> entities',
    () async {
      // assert
      expect(tPackagesModel, isA<List<Package>>());
      expect(tPackageModel, isA<Package>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid List<Package> when fromJsonList is called',
      () async {
        // arrange

        // act
        final result =
            PackageModel.fromJsonList(json.decode(fixture('gcpackages.json')));
        expect(result, tPackagesModel);
      },
    );

    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('gcpackage.json'));
        // act
        final result = PackageModel.fromJson(jsonMap);
        // assert
        expect(result, tPackageModel);
      },
    );
  });
}
