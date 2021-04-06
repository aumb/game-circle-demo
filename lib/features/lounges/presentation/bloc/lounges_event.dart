part of 'lounges_bloc.dart';

abstract class LoungesEvent extends Equatable {
  const LoungesEvent();

  @override
  List<Object?> get props => [];
}

class GetLoungesEvent extends LoungesEvent {}

class GetMoreLoungesEvent extends LoungesEvent {}

class RefreshLoungesEvent extends LoungesEvent {}
