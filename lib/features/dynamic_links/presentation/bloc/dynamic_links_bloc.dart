import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/managers/dynamic_links_manager.dart';
import 'package:gamecircle/core/managers/navgiation_manager.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';

part 'dynamic_links_event.dart';
part 'dynamic_links_state.dart';

class DynamicLinksBloc extends Bloc<DynamicLinksEvent, DynamicLinksState> {
  final DynamicLinksManager dynamicLinksManager;
  final AuthenticationBloc authenticationBloc;
  final NavigationManager navigationManager;
  final SessionManager sessionManager;

  DynamicLinksBloc({
    required this.dynamicLinksManager,
    required this.authenticationBloc,
    required this.navigationManager,
    required this.sessionManager,
  }) : super(DynamicLinksInitial()) {
    dynamicLinksManager.retrieveDynamicLink();
  }

  @override
  Stream<DynamicLinksState> mapEventToState(
    DynamicLinksEvent event,
  ) async* {
    if (event is HandleDynamicLinkEvent) {
      _handleDynamicLink();
    }
  }

  void _handleDynamicLink() {
    if (dynamicLinksManager.navigateTo != null) {
      if (authenticationBloc.state is AuthenticatedState &&
          sessionManager.user != null) {
        navigationManager.popTillFirst();
        navigationManager.navigateTo(dynamicLinksManager.navigateTo!);
        dynamicLinksManager.navigateTo = null;
      }
    }
  }
}
