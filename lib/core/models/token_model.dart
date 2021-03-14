import 'package:gamecircle/core/entities/token.dart';

class TokenModel extends Token {
  TokenModel({
    required String accessToken,
    required String refreshToken,
    String? tokenType,
    String? expiresIn,
  }) : super(
          accessToken: accessToken,
          refreshToken: refreshToken,
          tokenType: tokenType,
          expiresIn: expiresIn,
        );

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      refreshToken: json['refresh_token'],
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
}
