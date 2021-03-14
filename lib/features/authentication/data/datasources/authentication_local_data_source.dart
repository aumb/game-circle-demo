import 'dart:convert';

import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/features/login/data/datasources/login_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationLocalDataSource {
  Future<TokenModel?> getCachedToken();
}

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  final SharedPreferences sharedPreferences;

  const AuthenticationLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<TokenModel?> getCachedToken() {
    try {
      final String emptyToken =
          jsonEncode(TokenModel(accessToken: '', refreshToken: ''));
      final String? tokenString = sharedPreferences.getString(
        CACHED_TOKEN,
      );

      final TokenModel? tokenModel =
          TokenModel.fromJson(jsonDecode(tokenString ?? emptyToken));

      return Future.value(tokenModel);
    } catch (e) {
      print(e);
      throw ServerException(
          ServerError(message: "Could not access local storage", code: 401));
    }
  }
}
