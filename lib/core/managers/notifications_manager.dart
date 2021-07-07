import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gamecircle/core/utils/safe_print.dart';
import 'package:gamecircle/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:gamecircle/injection_container.dart';

class NotificationsManager {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void initializeNotifications() async {
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      safePrint("User granted notification permissions");

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final initialMessage =
            await FirebaseMessaging.instance.getInitialMessage();

        if (initialMessage != null) {
          safePrint("Initial Message is not null");
          safePrint(initialMessage.notification?.title ?? '');
          safePrint(initialMessage.notification?.body ?? '');
          safePrint(initialMessage.notification.toString());
          sl<NotificationsBloc>()
              .add(HandleNotificationEvent(remoteMessage: initialMessage));
        }

        FirebaseMessaging.onMessageOpenedApp.listen((event) {
          safePrint("on message Tap");
          safePrint(event.toString());
          sl<NotificationsBloc>()
              .add(HandleNotificationEvent(remoteMessage: event));
        });
      }
    } catch (e) {
      safePrint(e.toString());
    }
  }
}
