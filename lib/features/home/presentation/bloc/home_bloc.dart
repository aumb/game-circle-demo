import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_info.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_location.dart';
import 'package:geolocator/geolocator.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentUserInfo getCurrentUserInfo;
  final GetCurrentUserLocation getCurrentUserLocation;
  final SessionManager sessionManager;

  HomeBloc({
    required this.getCurrentUserInfo,
    required this.getCurrentUserLocation,
    required this.sessionManager,
  }) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetUserInformationEvent) {
      yield HomeLoading();
      final requests = await Future.wait([
        getCurrentUserInfo(NoParams()),
        getCurrentUserLocation(NoParams()),
      ]);
      final userInfoResponse = requests[0] as Either<Failure, User?>;
      final userLocationResponse = requests[1] as Either<Failure, Position?>;
      yield _handleHomeState(
        failureOrUser: userInfoResponse,
        failureOrUserLocation: userLocationResponse,
      );
    } else if (event is HomeRefreshEvent) {
      yield HomeRefreshing();
      final requests = await Future.wait([
        getCurrentUserInfo(NoParams()),
        getCurrentUserLocation(NoParams()),
      ]);
      final userInfoResponse = requests[0] as Either<Failure, User?>;
      final userLocationResponse = requests[1] as Either<Failure, Position?>;
      yield _handleHomeState(
        failureOrUser: userInfoResponse,
        failureOrUserLocation: userLocationResponse,
      );
    }
  }

  HomeState _handleHomeState({
    required Either<Failure, User?> failureOrUser,
    required Either<Failure, Position?> failureOrUserLocation,
  }) {
    return failureOrUser.fold((failure) {
      return _handleFailureEvent(failure);
    }, (user) {
      sessionManager.setUser(user);
      return _handleLocationState(failureOrUserLocation: failureOrUserLocation);
    });
  }

  HomeState _handleLocationState({
    required Either<Failure, Position?> failureOrUserLocation,
  }) {
    return failureOrUserLocation.fold((failure) {
      return _handleDiscreetFailureEvent(failure);
    }, (location) {
      sessionManager.setCoordinates(
        longitude: location?.longitude,
        latitude: location?.latitude,
      );
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

  LocationError _handleDiscreetFailureEvent(Failure failure) {
    LocationError error;
    if (failure is ServerFailure) {
      error = LocationError(message: failure.message);
    } else {
      error = LocationError(message: "unexpected_error");
    }

    return error;
  }
}
