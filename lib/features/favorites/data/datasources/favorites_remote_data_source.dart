import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<Lounge?>> getFavoriteLounges();

  Future<List<Lounge?>> getMoreFavoriteLounges();
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final Dio client;

  FavoritesRemoteDataSourceImpl({
    required this.client,
  });

  PaginationModel? paginationModel;

  @override
  Future<List<Lounge?>> getFavoriteLounges() async {
    try {
      final Response? response = await client.get(API.favoriteLounges);
      if (response?.statusCode == 200) {
        paginationModel = PaginationModel?.fromJson(response?.data);
        final lounges = LoungeModel.fromJsonList(paginationModel?.items);
        return lounges;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } on DioError catch (e) {
      final serverError = ServerError.fromJson(e.response?.data);
      throw ServerException(serverError);
    }
  }

  @override
  Future<List<Lounge?>> getMoreFavoriteLounges(
      {num? longitude, num? latitude, String? sortBy, String? query}) async {
    if (StringUtils().isNotEmpty(paginationModel?.meta.links?.next)) {
      try {
        final Response? response =
            await client.get(API.favoriteLounges, queryParameters: {
          "page": paginationModel!.meta.currentPage! + 1,
        });
        if (response?.statusCode == 200) {
          paginationModel = PaginationModel?.fromJson(response?.data);
          final lounges = LoungeModel.fromJsonList(paginationModel?.items);
          return lounges;
        } else {
          final serverError = ServerError.fromJson(null);
          throw ServerException(serverError);
        }
      } on DioError catch (e) {
        final serverError = ServerError.fromJson(e.response?.data);
        throw ServerException(serverError);
      }
    } else {
      return Future.value([]);
    }
  }
}
