import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'auth/bloC/auth_bloc.dart';
import 'auth/services/auth_service.dart';
import 'products/blocs/product_bloc.dart';
import 'products/services/product_services.dart';
import 'cart/blocs/cart_bloc.dart';
import 'cart/services/cart_service.dart';
import './screens/main_screen.dart';
import 'auth/screens/login.dart';
import 'auth/screens/register.dart';
import 'orders/bloc/order_bloc.dart';
import 'orders/services/order_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'notification/services/notification_service.dart';
import 'notification/screens/notification_screen.dart';
import './notification/bloc/notification_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Create and initialize notification service
  final notificationService = NotificationService();
  await notificationService.initNotifications();

  // Create a notification channel for Android
  if (Platform.isAndroid) {
    const channel = AndroidNotificationChannel(
      'orders', // Same ID as in NotificationService
      'Order Updates', // Same name as in NotificationService
      description: 'Notifications for order status updates',
      importance: Importance.high,
    );

    await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(AuthService())),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(ProductServices()),
        ),
        BlocProvider<CartBloc>(create: (context) => CartBloc(CartService())),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(OrderService(context), NotificationService()),
        ),
         BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(NotificationService()),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF097969)),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/': (context) => const MainScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/products': (context) => const MainScreen(),
          '/notification': (context) => NotificationScreen(),
        },
      ),
    );
  }
}
