import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User?>> postUserInformation({
    String? name,
    String? email,
    File? image,
  });
}
