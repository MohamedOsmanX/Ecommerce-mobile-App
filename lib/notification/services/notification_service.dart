import 'dart:convert';
import 'package:ecommerce_app/core/services/token_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../notification/models/notification_model.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final String baseUrl = ApiConstants.baseUrl; // Replace with your backend URL

  Future<void> initNotifications() async {
    print('Initializing notifications...');

    // Request permission
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission status: ${settings.authorizationStatus}');

    // Create the Android notification channel
    const androidChannel = AndroidNotificationChannel(
      'orders',
      'Order Updates',
      description: 'Notifications for order status updates',
      importance: Importance.high,
    );

    // Create the channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    final success = await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification clicked: ${details.payload}');
      },
    );

    print('Local notifications initialized: $success');
  }

  Future<void> sendOrderNotification(String orderId, String status) async {
    print('Sending order notification for order: $orderId');
    try {
      await _localNotifications.show(
        orderId.hashCode,
        'Order Update',
        'Order #$orderId is now $status',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'orders',
            'Order Updates',
            channelDescription: 'Notifications for order status updates',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
      print('Order notification sent successfully');
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> sendCartRminder(int itemCount) async {
    await _localNotifications.show(
      1,
      'Your Shopping Cart',
      'Your have $itemCount items waiting in your cart',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'cart',
          'Cart Reminders',
          importance: Importance.defaultImportance,
        ),
      ),
    );
  }

  // Get FCM token for this device
  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Fetch notifications from the backend
  Future<List<NotificationModel>> fetchNotifications() async {
    final token = await TokenService.getToken();
    if (token == null) {
    throw Exception('No auth token found');
  }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/my'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Replace with actual token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to fetch notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
