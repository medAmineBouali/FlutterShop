import 'package:flutter/material.dart';
import 'package:fluttershop/screens/cart_screen.dart';
import 'package:fluttershop/widgets/CustomNavBar.dart'; // Import the CustomNavBar
import 'home_screen.dart';
import 'explore_screen.dart';
import 'wishlist_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 📋 The List of pages we can switch between
  final List<Widget> _pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const WishlistScreen(),
    const CartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows content to go behind the nav bar if it's transparent/floating
      // 🧠 IndexedStack keeps the pages alive in memory so you don't lose your scroll position
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // Replace BottomNavigationBar with our CustomNavBar inside a positioned container
      // However, Scaffold's bottomNavigationBar property expects a Widget that sits at the bottom.
      // We can use it directly if it handles its own sizing, or wrap it.
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
