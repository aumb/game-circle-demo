import 'dart:convert';

import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/core/utils/const_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginLocalDataSource {
  Future<void> cacheToken(TokenModel? tokenModel);
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  final SharedPreferences sharedPreferences;

  const LoginLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<bool> cacheToken(TokenModel? tokenModel) {
    return sharedPreferences.setString(
      CACHED_TOKEN,
      json.encode(tokenModel?.toJson()),
    );
  }
}
