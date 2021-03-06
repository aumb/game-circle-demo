import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounges_filter_option.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_lounges.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_more_lounges.dart';

part 'lounges_event.dart';
part 'lounges_state.dart';

class LoungesBloc extends Bloc<LoungesEvent, LoungesState> {
  final GetLounges getLounges;
  final GetMoreLounges getMoreLounges;
  final SessionManager sessionManager;

  List<Lounge?> _lounges = [];
  List<Lounge?> get lounges => _lounges;

  bool canGetMoreLounges = true;

  LoungeFilterOption filter = LoungeFilterOption.distance;

  LoungesBloc({
    required this.getLounges,
    required this.getMoreLounges,
    required this.sessionManager,
  }) : super(LoungesLoading());

  @override
  Stream<LoungesState> mapEventToState(
    LoungesEvent event,
  ) async* {
    if (event is GetLoungesEvent) {
      canGetMoreLounges = true;
      if (state is! LoungesLoading) yield LoungesLoading();

      final lounges = await getLounges(
        GetLoungesParams(
          latitude: sessionManager.latitude,
          longitude: sessionManager.longitude,
          sortBy: filter.value.toLowerCase(),
        ),
      );
      yield* _handledGetLoungesState(lounges);
    } else if (event is GetMoreLoungesEvent) {
      if (state is! LoungesLoadingMore) yield LoungesLoadingMore();

      final lounges = await getMoreLounges(
        GetLoungesParams(
          latitude: sessionManager.latitude,
          longitude: sessionManager.longitude,
          sortBy: filter.value.toLowerCase(),
        ),
      );
      yield* _handledGetMoreLoungesState(lounges);
    } else if (event is RefreshLoungesEvent) {
      yield LoungesRefreshing();

      final lounges = await getLounges(
        GetLoungesParams(
          latitude: sessionManager.latitude,
          longitude: sessionManager.longitude,
          sortBy: filter.value.toLowerCase(),
        ),
      );
      yield* _handledRefreshingLoungesState(lounges);
    }
  }

  Stream<LoungesState> _handledGetLoungesState(
    Either<Failure, List<Lounge?>> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleFailureEvent(failure);
    }, (lounges) {
      _lounges = [];
      _lounges.addAll(lounges);
      return LoungesLoaded();
    });
  }

  Stream<LoungesState> _handledGetMoreLoungesState(
    Either<Failure, List<Lounge?>> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleGetMoreFailureEvent(failure);
    }, (lounges) {
      if (lounges.isEmpty) canGetMoreLounges = false;
      _lounges.addAll(lounges);
      return LoungesLoadedMore();
    });
  }

  Stream<LoungesState> _handledRefreshingLoungesState(
    Either<Failure, List<Lounge?>> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleGetMoreFailureEvent(failure);
    }, (lounges) {
      _lounges = [];
      _lounges.addAll(lounges);
      return LoungesRefreshed();
    });
  }

  LoungesError _handleFailureEvent(Failure failure) {
    LoungesError error;
    if (failure is ServerFailure) {
      error = LoungesError(message: failure.message, code: failure.code);
    } else {
      error = LoungesError(
        message: "unexpected_error",
        code: 500,
      );
    }

    return error;
  }

  LoungesErrorMore _handleGetMoreFailureEvent(Failure failure) {
    LoungesErrorMore error;
    if (failure is ServerFailure) {
      error = LoungesErrorMore(message: failure.message);
    } else {
      error = LoungesErrorMore(message: "unexpected_error");
    }

    return error;
  }

  void setFilter(LoungeFilterOption loungeFilterOption) {
    if (loungeFilterOption != filter) {
      canGetMoreLounges = true;
      filter = loungeFilterOption;
    }
  }
}
