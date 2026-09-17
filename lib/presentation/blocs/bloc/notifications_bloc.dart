import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/domain/entities/push_messages.dart';
import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final Future<void> Function()? requestLocalNotificationPermission;
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })?
  showLocalNotification;

  NotificationsBloc({
    this.requestLocalNotificationPermission,
    this.showLocalNotification,
  }) : super(NotificationsState()) {
    on<NotificationsStatusChange>(_notificationStatusChange);
    on<NotificationsReceive>(_onPushMessageReceived);

    _initialStatusChange();
    _onForegroundMessage();
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (requestLocalNotificationPermission != null) {
      await requestLocalNotificationPermission!();
    }

    add(NotificationsStatusChange(status: settings.authorizationStatus));
  }

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChange(
    NotificationsStatusChange event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(status: event.status));
    _getFirebaseMCToken();
  }

  void _onPushMessageReceived(
    NotificationsReceive event,
    Emitter<NotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        notifications: [event.pushMessages, ...state.notifications],
      ),
    );
    _getFirebaseMCToken();
  }

  void _initialStatusChange() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationsStatusChange(status: settings.authorizationStatus));
  }

  void _getFirebaseMCToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print(token);
  }

  void handleRemoteMessage(RemoteMessage message) async {
    if (message.notification == null) return;

    final notification = PushMessages(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sendDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );

    if (showLocalNotification != null) {
      showLocalNotification!(
        id: Random().nextInt(100),
        title: notification.title,
        body: notification.body,
        data: notification.messageId,
      );
    }
    add(NotificationsReceive(pushMessages: notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  PushMessages? getMessageById(String pushMessageId) {
    final exists = state.notifications.any(
      (element) => element.messageId == pushMessageId,
    );
    if (!exists) return null;

    return state.notifications.firstWhere(
      (element) => element.messageId == pushMessageId,
    );
  }
}
