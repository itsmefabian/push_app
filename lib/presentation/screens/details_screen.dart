import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/domain/entities/push_messages.dart';
import 'package:push_app/presentation/blocs/bloc/notifications_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final String pushMessageId;

  const new({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final PushMessages? message = context
        .watch<NotificationsBloc>()
        .getMessageById(pushMessageId);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification details')),
      body: message != null
          ? _DetailsView(message: message)
          : const Center(child: Text('Notification not found')),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessages message;
  const new({required this.message});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if (message.imageUrl != null) Image.network(message.imageUrl!),

          const SizedBox(height: 30),
          Text(message.title, style: textStyles.titleMedium),
          Text(message.body),
          const Divider(),
          Text(message.data.toString()),
        ],
      ),
    );
  }
}
