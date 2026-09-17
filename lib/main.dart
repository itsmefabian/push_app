import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:push_app/config/local_notifications/local_notifications.dart';
import 'package:push_app/config/theme/app_theme.dart';
import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/presentation/blocs/bloc/notifications_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFirebase();
  await LocalNotifications.initializeLocalNotifications();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => NotificationsBloc())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      builder: (context, child) =>
          HandleNotificationsInteractions(child: child!),
    );
  }
}

class HandleNotificationsInteractions extends StatefulWidget {
  final Widget child;
  const new({super.key, required this.child});

  @override
  State<HandleNotificationsInteractions> createState() =>
      _HandleNotificationsInteractionsState();
}

class _HandleNotificationsInteractionsState
    extends State<HandleNotificationsInteractions> {
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);

    appRouter.push(
      '/details/${message.messageId!.replaceAll(':', '').replaceAll('%', '')}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
