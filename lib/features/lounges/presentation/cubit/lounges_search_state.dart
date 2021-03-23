part of 'lounges_search_cubit.dart';

abstract class LoungesSearchState extends Equatable {
  const LoungesSearchState();

  @override
  List<Object?> get props => [];
}

class LoungesSearchInitial extends LoungesSearchState {}

class LoungesSearchLoading extends LoungesSearchState {}

class LoungesSearchLoaded extends LoungesSearchState {}

class LoungesSearchEmpty extends LoungesSearchState {}

class LoungesSearchError extends LoungesSearchState {
  final String? message;

  LoungesSearchError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoungesSearchLoadedMore extends LoungesSearchState {}

class LoungesSearchLoadingMore extends LoungesSearchState {}

class LoungesSearchErrorMore extends LoungesSearchState {
  final String? message;

  LoungesSearchErrorMore({required this.message});

  @override
  List<Object?> get props => [message];
}
