part of 'dynamic_links_bloc.dart';

abstract class DynamicLinksEvent extends Equatable {
  const DynamicLinksEvent();

  @override
  List<Object?> get props => [];
}

class HandleDynamicLinkEvent extends DynamicLinksEvent {}
