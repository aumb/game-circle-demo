import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/meta.dart';
import 'package:gamecircle/core/models/meta_model.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tMetaModel = MetaModel.fromJson(json.decode(fixture('meta.json')));

  test(
    'should be a subclass of MetaModel entity',
    () async {
      // assert
      expect(tMetaModel, isA<Meta>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('meta.json'));
        // act
        final result = MetaModel.fromJson(jsonMap);
        // assert
        expect(result, tMetaModel);
      },
    );
  });
}
