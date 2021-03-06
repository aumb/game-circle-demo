part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {}

class HomeRefreshing extends HomeState {}

class HomeError extends HomeState {
  final String? message;
  final int? code;
  HomeError({
    this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class LocationError extends HomeState {
  final String? message;
  LocationError({required this.message});

  @override
  List<Object?> get props => [message];
}
