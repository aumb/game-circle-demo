import 'dart:ui';

import 'package:dartz/dartz.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/locale/domain/repositories/locale_repository.dart';

class GetCachedLocale implements UseCase<Locale?, NoParams> {
  final LocaleRepository repository;

  GetCachedLocale(this.repository);

  @override
  Future<Either<Failure, Locale?>> call(NoParams params) async {
    return await repository.getCachedLocale();
  }
}
