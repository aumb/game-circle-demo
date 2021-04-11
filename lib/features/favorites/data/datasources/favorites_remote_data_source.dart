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

  Future<String?> toggleFavoriteLoungeStatus({required int id});
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
      final Response? response =
          await client.get(API.favoriteLounges, queryParameters: {
        "sort_by": "updated_at",
      });
      if (response?.statusCode == 200) {
        paginationModel = PaginationModel?.fromJson(response?.data);
        final lounges = LoungeModel.fromJsonList(paginationModel?.items);
        return lounges;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } catch (e) {
      throw ServerException.handleError(e);
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
          "sort_by": "updated_at",
        });
        if (response?.statusCode == 200) {
          paginationModel = PaginationModel?.fromJson(response?.data);
          final lounges = LoungeModel.fromJsonList(paginationModel?.items);
          return lounges;
        } else {
          final serverError = ServerError.fromJson(null);
          throw ServerException(serverError);
        }
      } catch (e) {
        throw ServerException.handleError(e);
      }
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<String?> toggleFavoriteLoungeStatus({required int id}) async {
    try {
      final url = API.favoriteLounges + "/" + id.toString();
      final Response? response = await client.post(url);
      if (response?.statusCode == 200) {
        final toggleLoungeSuccess = response?.data;
        return toggleLoungeSuccess;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } catch (e) {
      throw ServerException.handleError(e);
    }
  }
}
