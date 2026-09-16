part of 'notifications_bloc.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsStatusChange extends NotificationsEvent {
  final AuthorizationStatus status;

  const NotificationsStatusChange({required this.status});
}

class NotificationsReceive extends NotificationsEvent {
  final PushMessages pushMessages;

  const NotificationsReceive({required this.pushMessages});
}
