import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/features/profile/domain/usecases/post_user_information.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SessionManager sessionManager;
  final PostUserInformation postUserInformation;

  String? email;
  String? name;
  File? image;

  ProfileCubit({
    required this.sessionManager,
    required this.postUserInformation,
  }) : super(ProfileInitial()) {
    email = sessionManager.user?.email;
    name = sessionManager.user?.name;
  }

  bool get canSubmitPage =>
      !areValuesEmpty && (image != null || didNameChange || didEmailChange);

  bool get areValuesEmpty =>
      (StringUtils().isEmpty(email) && StringUtils().isEmpty(name));
  bool get isEmailValid => StringUtils().validateEmail(email ?? '');
  bool get isNameValid => StringUtils().validateName(name ?? '');
  bool get didEmailChange => email != sessionManager.user?.email;
  bool get didNameChange => name != sessionManager.user?.name;

  void submitProfile() async {
    emit(ProfileLoading());
    final user = await postUserInformation(PostUserInformationParams(
      email: didEmailChange ? email : '',
      name: didNameChange ? name : '',
      image: image,
    ));

    emit(_handleProfileState(user));
  }

  void setEmail(String? email) async {
    emit(ProfileEmailChanged());
    this.email = email;
  }

  void setName(String? name) async {
    emit(ProfileNameChanged());
    this.name = name;
  }

  void setImage(File? image) async {
    emit(ProfileImageChanged());
    this.image = image;
  }

  ProfileState _handleProfileState(Either<Failure, User?> user) {
    return user.fold(
      (failure) {
        return _handleFailureEvent(failure);
      },
      (user) {
        sessionManager.setUser(user);
        return ProfileLoaded();
      },
    );
  }

  ProfileError _handleFailureEvent(Failure failure) {
    ProfileError error;
    if (failure is ServerFailure) {
      error = ProfileError(message: failure.message);
    } else {
      error = ProfileError(message: "unexpected_error");
    }

    return error;
  }
}
