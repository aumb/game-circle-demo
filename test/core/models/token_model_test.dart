import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/core/entities/token.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tTokenModel =
      TokenModel(accessToken: "abcdefg", refreshToken: '123456');

  test(
    'should be a subclass of Token entity',
    () async {
      // assert
      expect(tTokenModel, isA<Token>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('token.json'));
        // act
        final result = TokenModel.fromJson(jsonMap);
        // assert
        expect(result, tTokenModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tTokenModel.toJson();
        // assert
        final expectedMap = {
          "access_token": "abcdefg",
          "refresh_token": "123456",
        };
        expect(result, expectedMap);
      },
    );
  });
}
