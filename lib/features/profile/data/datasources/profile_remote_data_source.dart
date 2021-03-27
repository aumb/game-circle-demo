import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/user_model.dart';
import 'package:gamecircle/core/utils/string_utils.dart';

abstract class ProfileRemoteDataSource {
  Future<User?> postUserInformation({
    String? name,
    String? email,
    File? image,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio client;

  ProfileRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<User?> postUserInformation(
      {String? name, String? email, File? image}) async {
    MultipartFile? _multipartImage;

    if (image != null) {
      _multipartImage = MultipartFile.fromFileSync(image.path);
    }

    final body = FormData.fromMap({
      if (StringUtils().isNotEmpty(name)) 'name': name,
      if (StringUtils().isNotEmpty(email)) 'email': email,
      if (_multipartImage != null) "image": _multipartImage,
    });

    try {
      final Response? response = await client.post(API.user, data: body);
      if (response?.statusCode == 200) {
        final user = UserModel.fromJson(response?.data);
        return user;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } on DioError catch (e) {
      ServerError error;
      try {
        error = ServerError.fromJson(e.response?.data);
      } catch (e) {
        error = ServerError.fromJson(null);
      }
      throw ServerException(error);
    }
  }
}
