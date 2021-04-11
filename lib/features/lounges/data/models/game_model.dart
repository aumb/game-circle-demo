import 'package:gamecircle/features/lounges/domain/entities/game.dart';

class GameModel extends Game {
  GameModel({
    required String? name,
    required String? nickname,
    required String? imgUrl,
  }) : super(
          name: name,
          nickname: nickname,
          imgUrl: imgUrl,
        );

  factory GameModel.fromJson(Map<String, dynamic>? json) {
    return GameModel(
      name: json?['name'],
      nickname: json?['nickname'],
      imgUrl: json?['image'],
    );
  }

  static List<GameModel> fromJsonList(List? json) {
    if (json != null && json.isNotEmpty) {
      List<GameModel> games =
          json.map((game) => GameModel.fromJson(game)).toList();
      return games;
    } else {
      return [];
    }
  }
}
