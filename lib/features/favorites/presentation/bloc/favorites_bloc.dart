import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_favorite_lounges.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_more_favorite_lounges.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoriteLounges getFavoriteLounges;
  final GetMoreFavoriteLounges getMoreFavoriteLounges;

  FavoritesBloc({
    required this.getFavoriteLounges,
    required this.getMoreFavoriteLounges,
  }) : super(FavoritesInitial());

  List<Lounge?> _lounges = [];
  List<Lounge?> get lounges => _lounges;

  bool canGetMoreLounges = true;

  @override
  Stream<FavoritesState> mapEventToState(
    FavoritesEvent event,
  ) async* {
    if (event is GetFavoriteLoungesEvent) {
      canGetMoreLounges = true;
      if (state is! FavoritesLoading) yield FavoritesLoading();
      final lounges = await getFavoriteLounges(NoParams());

      yield* _handleGetFavoriteLoungesState(lounges);
    } else if (event is GetMoreFavoriteLoungesEvent) {
      if (state is! FavoritesLoadingMore) yield FavoritesLoadingMore();

      final lounges = await getMoreFavoriteLounges(NoParams());

      yield* _handleGetMoreFavoriteLoungesState(lounges);
    }
  }

  Stream<FavoritesState> _handleGetMoreFavoriteLoungesState(
    Either<Failure, List<Lounge?>> failureOrLounges,
  ) async* {
    yield failureOrLounges.fold((failure) {
      return _handleGetMoreFailureEvent(failure);
    }, (lounges) {
      if (lounges.isEmpty) canGetMoreLounges = false;
      _lounges.addAll(lounges);
      return FavoritesLoadedMore();
    });
  }

  Stream<FavoritesState> _handleGetFavoriteLoungesState(
    Either<Failure, List<Lounge?>> failureOrLounges,
  ) async* {
    yield failureOrLounges.fold((failure) {
      return _handleFailureEvent(failure);
    }, (lounges) {
      _lounges = [];
      _lounges.addAll(lounges);
      return FavoritesLoaded();
    });
  }

  FavoritesErrorMore _handleGetMoreFailureEvent(Failure failure) {
    FavoritesErrorMore error;
    if (failure is ServerFailure) {
      error = FavoritesErrorMore(message: failure.message);
    } else {
      error = FavoritesErrorMore(message: "unexpected_error");
    }

    return error;
  }

  FavoritesError _handleFailureEvent(Failure failure) {
    FavoritesError error;
    if (failure is ServerFailure) {
      error = FavoritesError(
        message: failure.message,
        code: failure.code,
      );
    } else {
      error = FavoritesError(
        message: "unexpected_error",
        code: 500,
      );
    }

    return error;
  }
}
