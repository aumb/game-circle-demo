part of 'lounge_bloc.dart';

abstract class LoungeEvent extends Equatable {
  const LoungeEvent();

  @override
  List<Object> get props => [];
}

class GetLoungeEvent extends LoungeEvent {}

class ToggleFavoriteStatusEvent extends LoungeEvent {}
