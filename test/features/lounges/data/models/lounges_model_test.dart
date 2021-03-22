import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLoungeModel =
      LoungeModel.fromJson(json.decode(fixture('lounge.json')));
  final tPaginationModel =
      PaginationModel.fromJson(json.decode(fixture('lounges.json')));
  final tLoungesModel = LoungeModel.fromJsonList(tPaginationModel.items);
  test(
    'should be a subclass of Lounge and List<Lounge> entities',
    () async {
      // assert
      expect(tLoungesModel, isA<List<Lounge>>());
      expect(tLoungeModel, isA<Lounge>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid List<Lounge> when fromJsonList is called',
      () async {
        // arrange
        final tPaginationModel =
            PaginationModel.fromJson(json.decode(fixture('lounges.json')));
        final tLoungesModel = LoungeModel.fromJsonList(tPaginationModel.items);

        // act
        final result = LoungeModel.fromJsonList(tPaginationModel.items);
        expect(result, tLoungesModel);
      },
    );

    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('lounge.json'));
        // act
        final result = LoungeModel.fromJson(jsonMap);
        // assert
        expect(result, tLoungeModel);
      },
    );
  });
}
