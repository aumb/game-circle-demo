import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/data/models/game_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/game.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tGameModel = GameModel.fromJson(json.decode(fixture('game.json')));
  final tGamesModel =
      GameModel.fromJsonList(json.decode(fixture('games.json')));

  test(
    'should be a subclass of Lounge and List<Game> entities',
    () async {
      // assert
      expect(tGamesModel, isA<List<Game>>());
      expect(tGameModel, isA<Game>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid List<Game> when fromJsonList is called',
      () async {
        // arrange

        // act
        final result =
            GameModel.fromJsonList(json.decode(fixture('games.json')));
        expect(result, tGamesModel);
      },
    );

    test(
      'should return a valid model when called',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('game.json'));
        // act
        final result = GameModel.fromJson(jsonMap);
        // assert
        expect(result, tGameModel);
      },
    );
  });
}
