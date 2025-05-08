import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: BlocProvider(
        create: (context) => NotificationBloc(NotificationService())
          ..add(FetchNotificationsEvent()),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              final notifications = state.notifications;
              if (notifications.isEmpty) {
                return const Center(child: Text('No notifications'));
              }
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        notification.type == 'order' ? Icons.shopping_bag : Icons.shopping_cart,
                        color: notification.isRead
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(notification.message),
                      onTap: () {
                        // Handle notification tap
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Viewing notification: ${notification.title}')),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }
}