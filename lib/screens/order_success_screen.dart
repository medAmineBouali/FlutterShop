import 'package:flutter/material.dart';
import 'main_screen.dart'; // Import to navigate back to home

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Order Confirmation"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. Text Section
            const Text(
              "Order placed successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111618),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Your order has been placed and is being processed. You will receive an email confirmation shortly.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF111618),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            // 2. Illustration Image
            // I'm using a placeholder container here.
            // Replace the child with: Image.asset('assets/bag_image.png')
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3F1), // Light Greenish tint from design
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    // Using a placeholder network image that looks like a shopping bag
                    image: NetworkImage("https://cdn-icons-png.flaticon.com/512/3081/3081840.png"),
                    scale: 2.0, // Scale down the icon a bit
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 3. Continue Shopping Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // 🔄 Reset Navigation: Go back to the very start (MainScreen)
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                        (route) => false, // Remove all previous routes
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13B6EC), // 🎨 Exact Cyan Color
                  foregroundColor: const Color(0xFF111618), // Dark Text
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}