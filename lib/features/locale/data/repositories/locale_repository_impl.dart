import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/locale/data/datasources/locale_local_data_source.dart';
import 'package:gamecircle/features/locale/domain/repositories/locale_repository.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  final LocaleLocalDataSource localDataSource;

  const LocaleRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Locale?>> getCachedLocale() async {
    try {
      final locale = await localDataSource.getCachedLocale();
      return Right(locale);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
