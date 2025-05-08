import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationTestScreen extends StatelessWidget {
  final notificationService = NotificationService();

  NotificationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final token = await notificationService.getDeviceToken();
            print('Device Token: $token'); // Save this token to send notifications
          },
          child: const Text('Get Device Token'),
        ),
      ),
    );
  }
}