import 'dart:convert';

import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/core/utils/const_utils.dart';
import 'package:gamecircle/core/utils/safe_print.dart';
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
      safePrint(e.toString());
      throw ServerException(
          ServerError(message: "local_storage_access_error", code: 401));
    }
  }
}
