import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_info.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentUserInfo getCurrentUserInfo;
  HomeBloc({
    required this.getCurrentUserInfo,
  }) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetUserInformationEvent) {
      yield HomeLoading();
      final requests = await Future.wait([getCurrentUserInfo(NoParams())]);
      yield* _handleHomeState(failureOrUser: requests[0]);
    }
  }

  Stream<HomeState> _handleHomeState({
    required Either<Failure, User?> failureOrUser,
  }) async* {
    yield failureOrUser.fold((failure) {
      return _handleFailureEvent(failure);
    }, (user) {
      return HomeLoaded();
    });
  }

  HomeError _handleFailureEvent(Failure failure) {
    HomeError error;
    if (failure is ServerFailure) {
      error = HomeError(message: failure.message);
    } else {
      error = HomeError(message: "unexpected_error");
    }

    return error;
  }
}
