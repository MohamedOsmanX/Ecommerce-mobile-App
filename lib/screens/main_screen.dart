import 'package:flutter/material.dart';
import '../../products/screens/product_list_screen.dart';
import '../cart/screens/cartScreen.dart';
import '../profile/screens/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  String getUserRole() {
    // In a real app, you'd get this from your auth state
    // For now, return 'seller' so you can see both notification types
    return 'seller';
  }

  final List<Widget> _screens = [
    const ProductListScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('app_name'.tr()),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          actions: [
            IconButton(
              onPressed: () {
                context.locale.languageCode == 'en'
                    ? context.setLocale(const Locale('ar'))
                    : context.setLocale(const Locale('en'));
              },
              icon: const Icon(Icons.language),
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed:
                      () => Navigator.pushNamed(context, '/notification'),
                  tooltip: 'Notifications',
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr()),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'cart'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'profile'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
