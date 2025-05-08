import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'notification/screens/test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final notificationService = NotificationService();
  await notificationService.initNotifications();
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
          create: (context) => OrderBloc(OrderService(context)),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF097969)),
          useMaterial3: true,
        ),
        initialRoute: '/notification',
        routes: {
          '/': (context) => const MainScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/products': (context) => const MainScreen(),
          '/notification': (context) => NotificationTestScreen(),
        },
      ),
    );
  }
}
