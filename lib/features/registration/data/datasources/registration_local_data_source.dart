import 'dart:convert';

import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/core/utils/const_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RegistrationLocalDataSource {
  Future<void> cacheToken(TokenModel? tokenModel);
}

class RegistrationLocalDataSourceImpl implements RegistrationLocalDataSource {
  final SharedPreferences sharedPreferences;

  const RegistrationLocalDataSourceImpl({
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
