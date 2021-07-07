part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class HandleNotificationEvent extends NotificationsEvent {
  final RemoteMessage remoteMessage;

  HandleNotificationEvent({
    required this.remoteMessage,
  });

  @override
  List<Object?> get props => [remoteMessage];
}
