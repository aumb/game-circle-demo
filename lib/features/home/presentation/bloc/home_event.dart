part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetUserInformationEvent extends HomeEvent {}

class HomeRefreshEvent extends HomeEvent {}
