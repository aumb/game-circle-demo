part of 'logout_cubit.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutLoaded extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutError extends LogoutState {
  final String? message;

  LogoutError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
