import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/errors/failure.dart';

abstract class LocaleRepository {
  Future<Either<Failure, Locale?>> getCachedLocale();
}
