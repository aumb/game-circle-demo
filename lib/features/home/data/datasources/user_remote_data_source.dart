import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<User?> getCurrentUserInfo();

  Future<User?> getUserInfo(int? id);

  Future<User?> postLogoutUser();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio client;

  UserRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<User?> postLogoutUser() async {
    try {
      final Response? response = await client.post(API.logout);
      if (response?.statusCode == 200) {
        return UserModel.fromJson(response?.data);
      }
    } on DioError catch (e) {
      final serverError = ServerError.fromJson(e.response?.data);
      throw ServerException(serverError);
    }
  }

  @override
  Future<UserModel?> getCurrentUserInfo() {
    return _getUserFromBody();
  }

  @override
  Future<UserModel?> getUserInfo(int? id) {
    return _getUserFromBody(id);
  }

  Future<UserModel?> _getUserFromBody([int? id]) async {
    try {
      final String url = id != null ? "${API.users}/$id" : API.user;
      final Response? response = await client.get(url);
      if (response?.statusCode == 200) {
        return UserModel.fromJson(response?.data);
      }
    } on DioError catch (e) {
      final serverError = ServerError.fromJson(e.response?.data);
      throw ServerException(serverError);
    }
  }
}
