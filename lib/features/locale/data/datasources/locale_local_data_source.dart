import 'package:flutter/material.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/utils/const_utils.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocaleLocalDataSource {
  Future<Locale?> getCachedLocale();
}

class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
  final SharedPreferences sharedPreferences;

  const LocaleLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<Locale?> getCachedLocale() {
    try {
      final String defaultLocale = 'en';
      final String? cachedLocale = sharedPreferences.getString(
        CACHED_LOCALE,
      );
      final String localeString =
          StringUtils().isEmpty(cachedLocale) ? defaultLocale : cachedLocale!;
      final Locale locale = Locale(
        localeString,
        _getCountry(localeString),
      );

      return Future.value(locale);
    } catch (e) {
      throw ServerException(
          ServerError(message: "local_storage_access_error", code: 401));
    }
  }

  String _getCountry(String localeString) {
    switch (localeString) {
      case 'ar':
        return 'LB';
      case 'en':
        return 'US';
      default:
        return '';
    }
  }
}
