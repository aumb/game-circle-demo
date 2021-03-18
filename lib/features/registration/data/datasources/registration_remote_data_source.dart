import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/core/models/user_model.dart';

abstract class RegistrationRemoteDataSource {
  /// Calls the /register endpoint with email and password params.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TokenModel?> postEmailRegistration({
    String? email,
    String? name,
    String? password,
    String? confirmPassword,
  });
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final Dio client;

  RegistrationRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<TokenModel?> postEmailRegistration({
    String? email,
    String? name,
    String? password,
    String? confirmPassword,
  }) async {
    FormData body = FormData.fromMap(UserModel(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      name: name,
    ).toJson());
    try {
      final Response? response = await client.post(API.register, data: body);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return TokenModel.fromJson(response?.data);
      }
    } on DioError catch (e) {
      final serverError = ServerError.fromJson(e.response?.data);
      throw ServerException(serverError);
    }
  }
}
