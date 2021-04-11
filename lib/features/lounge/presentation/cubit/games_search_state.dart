part of 'games_search_cubit.dart';

abstract class GamesSearchState extends Equatable {
  const GamesSearchState();

  @override
  List<Object> get props => [];
}

class GamesSearchInitial extends GamesSearchState {}

class GamesSearchLoading extends GamesSearchState {}

class GamesSearchLoaded extends GamesSearchState {}

class GamesSearchEmpty extends GamesSearchState {}
