import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/profile/domain/repositories/profile_repository.dart';

class PostUserInformation implements UseCase<User?, PostUserInformationParams> {
  final ProfileRepository repository;

  PostUserInformation(this.repository);

  @override
  Future<Either<Failure, User?>> call(PostUserInformationParams params) async {
    return await repository.postUserInformation(
      name: params.name,
      email: params.email,
      image: params.image,
    );
  }
}

class PostUserInformationParams extends Equatable {
  final String? name;
  final String? email;
  final File? image;

  PostUserInformationParams({
    this.email,
    this.name,
    this.image,
  });

  @override
  List<Object?> get props => [name, email, image];
}
