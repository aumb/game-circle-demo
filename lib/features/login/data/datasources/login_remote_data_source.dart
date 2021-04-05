import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/utils/safe_print.dart';
import 'package:gamecircle/core/utils/string_utils.dart';

import 'package:gamecircle/core/models/token_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class LoginRemoteDataSource {
  Future<TokenModel?> postEmailLogin(String? email, String? password);

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
          ServerError(code: 401, message: "social_provider_error"),
        );
      }

      return accessToken;
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          throw ServerException(
            ServerError(code: 401, message: "social_provider_error"),
          );
        case FacebookAuthErrorCode.CANCELLED:
          throw ServerException(
            ServerError(code: 401, message: "social_provider_error"),
          );
        case FacebookAuthErrorCode.FAILED:
          throw ServerException(
            ServerError(code: 401, message: "social_provider_error"),
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
          ServerError(code: 401, message: "social_provider_error"),
        );
      }
      googleSignIn.signOut();
      return googleSignInAuthentication;
    } catch (e) {
      throw ServerException(
        ServerError(code: 401, message: "social_provider_error"),
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
    } catch (e) {
      throw ServerException.handleError(e);
    }
  }
}
