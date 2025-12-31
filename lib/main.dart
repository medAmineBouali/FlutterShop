import 'package:flutter/material.dart';
import 'package:fluttershop/screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()),

        // 2. CHECK THIS LINE: Did you add this?
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const FlutterShopApp(),
    ),
  );
}

class FlutterShopApp extends StatelessWidget {
  const FlutterShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the red "Debug" banner
      title: 'FlutterShop',

      // 🎨 Theme Settings: Matching your "Minimalist" Design
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true, // Enables the latest Flutter UI behaviors
        fontFamily: 'Inter', // Note: Make sure you add this font to pubspec.yaml later if needed

        // Global AppBar Theme (White background, black text)
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent, // Prevents the M3 color tint on scroll
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),

        // Color Scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          secondary: Colors.grey,
        ),
      ),

      // 🏠 The Entry Point
      home: const MainScreen(),
    );
  }
}