import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

abstract class LoungesRemoteDataSource {
  Future<List<Lounge?>> getLounges({
    num? longitude,
    num? latitude,
    String? sortBy,
    String? query,
  });

  Future<List<Lounge?>> getMoreLounges({
    num? longitude,
    num? latitude,
    String? sortBy,
    String? query,
  });
}

class LoungesRemoteDataSourceImpl implements LoungesRemoteDataSource {
  final Dio client;

  LoungesRemoteDataSourceImpl({
    required this.client,
  });

  PaginationModel? paginationModel;

  @override
  Future<List<Lounge?>> getLounges({
    num? longitude,
    num? latitude,
    String? sortBy,
    String? query,
  }) async {
    try {
      final Response? response =
          await client.get(API.lounges, queryParameters: {
        if (longitude != null) "longitude": longitude,
        if (latitude != null) "latitude": latitude,
        if (StringUtils().isNotEmpty(sortBy)) "sort_by": sortBy,
        if (StringUtils().isNotEmpty(query)) "q": query,
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
  }

  @override
  Future<List<Lounge?>> getMoreLounges(
      {num? longitude, num? latitude, String? sortBy, String? query}) async {
    if (StringUtils().isNotEmpty(paginationModel?.meta.links?.next)) {
      try {
        final Response? response =
            await client.get(API.lounges, queryParameters: {
          if (longitude != null) "longitude": longitude,
          if (latitude != null) "latitude": latitude,
          if (StringUtils().isNotEmpty(sortBy)) "sort_by": sortBy,
          if (StringUtils().isNotEmpty(query)) "q": query,
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
