import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/user_model.dart';
import 'package:geolocator/geolocator.dart';

abstract class UserRemoteDataSource {
  Future<User?> getCurrentUserInfo();

  Future<User?> getUserInfo(int? id);

  Future<User?> postLogoutUser();

  Future<Position> getCurrentUserPosition();
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
    } catch (e) {
      throw ServerException.handleError(e);
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
    } catch (e) {
      throw ServerException.handleError(e);
    }
  }

  @override
  Future<Position> getCurrentUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled()
        .catchError((e) async => false);

    if (!serviceEnabled) {
      throw ServerException(
          ServerError(message: 'Location services are disabled.', code: 402));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw ServerException(ServerError(
            message:
                'Location permissions are permanently denied, we cannot request permissions.',
            code: 402));
      }

      if (permission == LocationPermission.denied) {
        throw ServerException(
            ServerError(message: 'Location permissions are denied', code: 402));
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
