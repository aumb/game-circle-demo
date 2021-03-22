import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/links.dart';
import 'package:gamecircle/core/models/links_model.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tLinksModel = LinksModel.fromJson(json.decode(fixture('links.json')));

  test(
    'should be a subclass of LinksModel entity',
    () async {
      // assert
      expect(tLinksModel, isA<Links>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('links.json'));
        // act
        final result = LinksModel.fromJson(jsonMap);
        // assert
        expect(result, tLinksModel);
      },
    );
  });
}
