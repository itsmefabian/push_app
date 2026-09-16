import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/details/:messageId',
      builder: (context, state) {
        final messageId = state.pathParameters['messageId'] ?? '';
        return DetailsScreen(pushMessageId: messageId);
      },
    ),
  ],
);
