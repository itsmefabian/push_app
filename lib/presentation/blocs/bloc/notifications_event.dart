part of 'notifications_bloc.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsStatusChange extends NotificationsEvent {
  final AuthorizationStatus status;

  new({required this.status});

  


}
