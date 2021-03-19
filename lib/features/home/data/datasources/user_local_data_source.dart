import 'package:gamecircle/core/utils/const_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<bool> deleteCachedToken();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  const UserLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<bool> deleteCachedToken() {
    return sharedPreferences.remove(CACHED_TOKEN);
  }
}
