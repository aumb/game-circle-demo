import 'package:dio/dio.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

abstract class LoungeRemoteDataSource {
  Future<Lounge?> getLounge({
    required int id,
  });
}

class LoungeRemoteDataSourceImpl implements LoungeRemoteDataSource {
  final Dio client;

  LoungeRemoteDataSourceImpl({
    required this.client,
  });

  PaginationModel? paginationModel;

  @override
  Future<Lounge?> getLounge({
    required int id,
  }) async {
    try {
      final url = API.lounges + "/" + id.toString();
      final Response? response = await client.get(url);
      if (response?.statusCode == 200) {
        final lounge = LoungeModel.fromJson(response?.data);
        return lounge;
      } else {
        final serverError = ServerError.fromJson(null);
        throw ServerException(serverError);
      }
    } catch (e) {
      throw ServerException.handleError(e);
    }
  }
}
