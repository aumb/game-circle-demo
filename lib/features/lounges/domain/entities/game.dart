import 'package:equatable/equatable.dart';

class Game extends Equatable {
  final String? name;
  final String? nickname;
  final String? imgUrl;

  Game({
    required this.name,
    required this.nickname,
    required this.imgUrl,
  });

  @override
  List<Object?> get props => [name, nickname, imgUrl];
}
