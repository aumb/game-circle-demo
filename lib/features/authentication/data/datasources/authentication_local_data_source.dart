import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/core/utils/const_utils.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/injection_container.dart';
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

      setUpTokenInClient(tokenModel);

      return Future.value(tokenModel);
    } catch (e) {
      throw ServerException(
          ServerError(message: "local_storage_access_error", code: 401));
    }
  }

  void setUpTokenInClient(TokenModel? tokenModel) {
    final Map<String, dynamic> headers = sl<Dio>().options.headers;
    if (StringUtils().isNotEmpty(tokenModel?.accessToken)) {
      headers['Authorization'] = "Bearer " + tokenModel!.accessToken;
    } else {
      if (headers.containsKey('Authorization')) {
        headers.removeWhere((key, value) => key == 'Authorization');
      }
    }
  }
}
