part of 'lounge_bloc.dart';

abstract class LoungeState extends Equatable {
  const LoungeState();

  @override
  List<Object?> get props => [];
}

class LoungeInitial extends LoungeState {}

class LoungeLoading extends LoungeState {}

class LoungeLoaded extends LoungeState {}

class LoungeError extends LoungeState {
  final String? message;
  final int? code;

  LoungeError({this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class FavoriteLoading extends LoungeState {}

class FavoriteLoaded extends LoungeState {}

class FavoriteError extends LoungeState {
  final String? message;

  FavoriteError({this.message});

  @override
  List<Object?> get props => [message];
}
