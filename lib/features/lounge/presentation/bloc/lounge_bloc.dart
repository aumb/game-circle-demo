import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/favorites/domain/usecases/toggle_lounge_favorite_status.dart';
import 'package:gamecircle/features/lounge/domain/usecases/get_lounge.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/lounges/domain/entities/timing.dart';

part 'lounge_event.dart';
part 'lounge_state.dart';

class LoungeBloc extends Bloc<LoungeEvent, LoungeState> {
  final Lounge lounge;
  final GetLounge getLounge;
  final ToggleLoungeFavoriteStatus toggleLoungeFavoriteStatus;

  Lounge? _fullLounge;
  Lounge? get fullLounge => _fullLounge;

  late bool _isFavorite;
  bool get isFavorite => _isFavorite;

  List<Timing?> _timings = [];
  List<Timing?> get timings => _timings;

  LoungeBloc({
    required this.lounge,
    required this.toggleLoungeFavoriteStatus,
    required this.getLounge,
  }) : super(LoungeInitial()) {
    _fullLounge = lounge;
    _timings = _getLoungeTimings();
    _isFavorite = _fullLounge?.isFavorite ?? false;
  }

  @override
  Stream<LoungeState> mapEventToState(
    LoungeEvent event,
  ) async* {
    if (event is GetLoungeEvent) {
      yield LoungeLoading();

      final loungeResponse = await getLounge(
        GetLoungeParams(
          id: lounge.id ?? 0,
        ),
      );
      yield* _handledGetLoungeState(loungeResponse);
    } else if (event is ToggleFavoriteStatusEvent) {
      yield FavoriteLoading();

      final favoriteResponse = await toggleLoungeFavoriteStatus(
        ToggleLoungeFavoriteStatusParams(id: _fullLounge?.id ?? 0),
      );
      yield* _handleToggleLoungeFavoriteStatus(favoriteResponse);
    }
  }

  Stream<LoungeState> _handleToggleLoungeFavoriteStatus(
    Either<Failure, String?> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleFavoriteFailureEvent(failure);
    }, (favorited) {
      _isFavorite = !isFavorite;
      return FavoriteLoaded();
    });
  }

  FavoriteError _handleFavoriteFailureEvent(Failure failure) {
    FavoriteError error;
    if (failure is ServerFailure) {
      error = FavoriteError(message: failure.message);
    } else {
      error = FavoriteError(message: "unexpected_error");
    }

    return error;
  }

  Stream<LoungeState> _handledGetLoungeState(
    Either<Failure, Lounge?> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleFailureEvent(failure);
    }, (lounge) {
      _fullLounge = lounge;
      return LoungeLoaded();
    });
  }

  LoungeError _handleFailureEvent(Failure failure) {
    LoungeError error;
    if (failure is ServerFailure) {
      error = LoungeError(message: failure.message, code: failure.code);
    } else {
      error = LoungeError(
        message: "unexpected_error",
        code: 500,
      );
    }

    return error;
  }

  List<Timing?> _getLoungeTimings() {
    List<Timing?> _timings = [];
    _timings.addAll(_fullLounge!.timings!);
    for (int i = 0; i < 7; i++) {
      Timing? _timing = _timings.firstWhere(
        (element) => element?.day == i,
        orElse: () => null,
      );
      if (_timing == null) {
        _timings.add(
          Timing(open: false, day: i, openTime: null, closeTime: null),
        );
      }
    }

    _timings.sort((a, b) => a!.day!.compareTo(b!.day!));

    return _timings;
  }
}
