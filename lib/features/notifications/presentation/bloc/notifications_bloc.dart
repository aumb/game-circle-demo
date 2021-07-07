import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gamecircle/core/managers/notifications_manager.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsManager notificationsManager;
  NotificationsBloc({
    required this.notificationsManager,
  }) : super(NotificationsInitial()) {
    notificationsManager.initializeNotifications();
  }

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    if (event is HandleNotificationEvent) {
      _handleNotificationEvent(event.remoteMessage);
    }
  }

  void _handleNotificationEvent(RemoteMessage notification) {
    print("HELLO");
  }
}
