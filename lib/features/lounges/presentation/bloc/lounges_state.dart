part of 'lounges_bloc.dart';

abstract class LoungesState extends Equatable {
  const LoungesState();

  @override
  List<Object?> get props => [];
}

class LoungesInitial extends LoungesState {}

class LoungesLoading extends LoungesState {}

class LoungesLoaded extends LoungesState {}

class LoungesLoadingMore extends LoungesState {}

class LoungesLoadedMore extends LoungesState {}

class LoungesErrorMore extends LoungesState {
  final String? message;

  LoungesErrorMore({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoungesError extends LoungesState {
  final String? message;
  final int? code;

  LoungesError({this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}
