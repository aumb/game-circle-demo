import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String tokenType;
  final String expiresIn;
  final String accessToken;
  final String refreshToken;

  Token(
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
  );

  @override
  List<Object> get props => [tokenType, expiresIn, accessToken, refreshToken];
}
