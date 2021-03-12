import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';

import 'package:gamecircle/features/login/data/models/token_model.dart';

abstract class LoginRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TokenModel?> postEmailLogin(String? email, String? password);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TokenModel?> postSocialLogin(String? provider, String? token);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio client;

  LoginRemoteDataSourceImpl({required this.client});

  @override
  Future<TokenModel?> postEmailLogin(String? email, String? password) =>
      _getTokenFromBody(FormData.fromMap({
        'email': email,
        'password': password,
      }));

  @override
  Future<TokenModel?> postSocialLogin(String? provider, String? token) =>
      _getTokenFromBody(FormData.fromMap({
        'provider': provider,
        'token': token,
      }));

  Future<TokenModel?> _getTokenFromBody(FormData? body) async {
    try {
      final Response? response = await client.post(API.login, data: body);
      if (response?.statusCode == 200) {
        return TokenModel.fromJson(response?.data);
      }
    } on DioError catch (e) {
      final serverError = ServerError.fromJson(e.response?.data);
      throw ServerException(serverError);
    } catch (e) {
      print(e);
      throw ServerException(
          ServerError(code: 500, message: "An unexpected error has occured"));
    }
  }
}
