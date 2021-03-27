part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String? message;

  ProfileError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class ProfileEmailChanged extends ProfileState {}

class ProfileNameChanged extends ProfileState {}

class ProfileImageChanged extends ProfileState {}
