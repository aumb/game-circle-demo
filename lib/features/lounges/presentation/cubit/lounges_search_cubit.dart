import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounges_filter_option.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_lounges.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_more_lounges.dart';

part 'lounges_search_state.dart';

class LoungesSearchCubit extends Cubit<LoungesSearchState> {
  final GetLounges getLounges;
  final GetMoreLounges getMoreLounges;
  final num? userLongitude;
  final num? userLatitude;

  List<Lounge?> _lounges = [];
  List<Lounge?> get lounges => _lounges;

  bool canGetMoreLounges = true;

  String query = '';

  LoungeFilterOption filter = LoungeFilterOption.name;

  late CancelableOperation? _cancelableOperation;

  LoungesSearchCubit({
    required this.getLounges,
    required this.getMoreLounges,
    this.userLatitude = 34,
    this.userLongitude = 33,
  }) : super(LoungesSearchInitial()) {
    _cancelableOperation = null;
  }

  void search() {
    canGetMoreLounges = true;
    _cancelableOperation?.cancel();
    if (_lounges.isEmpty) emit(LoungesSearchInitial());
    _cancelableOperation = CancelableOperation.fromFuture(
      _cancelableFuture(),
    );
  }

  void loadMore() async {
    if (!(_cancelableOperation?.isCanceled ?? true)) {
      emit(LoungesSearchLoadingMore());
      final lounges = await getMoreLounges(GetLoungesParams(
        latitude: userLatitude,
        longitude: userLongitude,
        sortBy: filter.value.toLowerCase(),
        query: query,
      ));
      emit(_handledGetMoreLoungesState(lounges));
    }
  }

  Future<void> _cancelableFuture() {
    emit(LoungesSearchLoading());
    return getLounges(GetLoungesParams(
      latitude: userLatitude,
      longitude: userLongitude,
      sortBy: filter.value.toLowerCase(),
      query: query,
    )).then((lounges) {
      if (!(_cancelableOperation?.isCanceled ?? true))
        return emit(_handledGetLoungesState(lounges));
    });
  }

  LoungesSearchState _handledGetLoungesState(
    Either<Failure, List<Lounge?>> failureOrToken,
  ) {
    return failureOrToken.fold((failure) {
      return _handleFailureEvent(failure);
    }, (lounges) {
      _lounges = [];
      _lounges.addAll(lounges);
      if (_lounges.isEmpty) {
        return LoungesSearchEmpty();
      } else {
        return LoungesSearchLoaded();
      }
    });
  }

  LoungesSearchState _handledGetMoreLoungesState(
    Either<Failure, List<Lounge?>> failureOrToken,
  ) {
    return failureOrToken.fold((failure) {
      return _handleGetMoreFailureEvent(failure);
    }, (lounges) {
      if (lounges.isEmpty) canGetMoreLounges = false;
      _lounges.addAll(lounges);
      return LoungesSearchLoaded();
    });
  }

  LoungesSearchError _handleFailureEvent(Failure failure) {
    LoungesSearchError error;
    if (failure is ServerFailure) {
      error = LoungesSearchError(message: failure.message);
    } else {
      error = LoungesSearchError(message: "unexpected_error");
    }

    return error;
  }

  LoungesSearchErrorMore _handleGetMoreFailureEvent(Failure failure) {
    LoungesSearchErrorMore error;
    if (failure is ServerFailure) {
      error = LoungesSearchErrorMore(message: failure.message);
    } else {
      error = LoungesSearchErrorMore(message: "unexpected_error");
    }

    return error;
  }
}
