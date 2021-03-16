import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/models/user_token.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tUserModelFromJson = UserModel(
    id: 1,
    name: "mathiew",
    email: "mathiew95@gmail.com",
    imageUrl: "test",
  );

  final tUserModelToJson = UserModel(
    id: 1,
    name: "mathiew",
    email: "mathiew95@gmail.com",
    password: "test",
    confirmPassword: "test",
  );

  test(
    'should be a subclass of Token entity',
    () async {
      // assert
      expect(tUserModelFromJson, isA<User>());
      expect(tUserModelToJson, isA<User>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));
        // act
        final result = UserModel.fromJson(jsonMap);
        // assert
        expect(result, tUserModelFromJson);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tUserModelToJson.toJson();
        // assert
        final expectedMap = {
          "id": 1,
          "name": "mathiew",
          "email": "mathiew95@gmail.com",
          "password": "test",
          "confirm_password": "test",
        };
        expect(result, expectedMap);
      },
    );
  });
}
