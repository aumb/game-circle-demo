part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {}

class FavoritesError extends FavoritesState {
  final String? message;

  FavoritesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class FavoritesErrorMore extends FavoritesState {
  final String? message;

  FavoritesErrorMore({required this.message});

  @override
  List<Object?> get props => [message];
}

class FavoritesLoadingMore extends FavoritesState {}

class FavoritesLoadedMore extends FavoritesState {}
