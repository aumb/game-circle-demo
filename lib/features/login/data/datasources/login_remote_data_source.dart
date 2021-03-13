import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/utils/string_utils.dart';

import 'package:gamecircle/features/login/data/models/token_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class LoginRemoteDataSource {
  /// Calls the /login endpoint with email and password params.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TokenModel?> postEmailLogin(String? email, String? password);

  /// Calls the /login endpoint with provider name and token.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TokenModel?> postSocialLogin(String? provider, String? token);

  Future<GoogleSignInAuthentication?> postGoogleLogin();

  Future<AccessToken?> postFacebookLogin();
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio client;
  final GoogleSignIn googleSignIn;
  final FacebookAuth facebookSignIn;

  LoginRemoteDataSourceImpl({
    required this.client,
    required this.googleSignIn,
    required this.facebookSignIn,
  });

  @override
  Future<AccessToken?> postFacebookLogin() async {
    try {
      // by default the login method has the next permissions ['email','public_profile']
      AccessToken? accessToken = await facebookSignIn.login();
      if (StringUtils().isEmpty(accessToken?.token)) {
        throw ServerException(
          ServerError(
              code: 401, message: "Could not get information from facebook"),
        );
      }

      return accessToken;
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          throw ServerException(
            ServerError(
                code: 401,
                message: "You have a previous login operation in progress"),
          );
        case FacebookAuthErrorCode.CANCELLED:
          throw ServerException(
            ServerError(
                code: 401, message: "Could not get information from facebook"),
          );
        case FacebookAuthErrorCode.FAILED:
          throw ServerException(
            ServerError(
                code: 401, message: "Could not get information from facebook"),
          );
      }
    }
  }

  @override
  Future<GoogleSignInAuthentication?> postGoogleLogin() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      if (StringUtils().isEmpty(googleSignInAuthentication?.accessToken)) {
        throw ServerException(
          ServerError(
              code: 401, message: "Could not get information from google"),
        );
      }
      googleSignIn.signOut();
      return googleSignInAuthentication;
    } catch (e) {
      print(e);
      throw ServerException(
        ServerError(
            code: 401, message: "Could not get information from google"),
      );
    }
  }

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
    }
  }
}
