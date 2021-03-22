part of 'lounges_bloc.dart';

abstract class LoungesEvent extends Equatable {
  const LoungesEvent();

  @override
  List<Object?> get props => [];
}

class GetLoungesEvent extends LoungesEvent {
  // final String? sortBy;
  // final num? longitude;
  // final num? latitude;

  // GetLoungesEvent({
  //   required this.sortBy,
  //   required this.longitude,
  //   required this.latitude,
  // });

  // @override
  // List<Object?> get props => [sortBy, longitude, latitude];
}

class GetMoreLoungesEvent extends LoungesEvent {}
