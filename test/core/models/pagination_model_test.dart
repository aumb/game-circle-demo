import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/pagination_model.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tPaginationModel =
      PaginationModel.fromJson(json.decode(fixture('pagination.json')));

  test(
    'should be a subclass of PaginationModel entity',
    () async {
      // assert
      expect(tPaginationModel, isA<PaginationModel>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('pagination.json'));
        // act
        final result = PaginationModel.fromJson(jsonMap);
        // assert
        expect(result, tPaginationModel);
      },
    );
  });
}
