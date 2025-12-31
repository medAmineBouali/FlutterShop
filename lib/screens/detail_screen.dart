import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. App Bar with "Heart" icon
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
          actions: [
            // WRAP the button in a Consumer to listen to changes
            Consumer<WishlistProvider>(
              builder: (context, provider, child) {
                // 1. Check if this specific product is already in the list
                bool isFav = provider.isFavorite(product);

                return IconButton(
                  icon: Icon(
                    // 2. If favorite, show filled Heart. If not, show Border.
                    isFav ? Icons.favorite : Icons.favorite_border,
                    // 3. If favorite, make it Red. If not, Black.
                    color: isFav ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    // 4. Call the toggle function we wrote in the Provider
                    provider.toggleFavorite(product);

                    // 5. Show a feedback message
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFav ? "Removed from Wishlist" : "Added to Wishlist"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 8),
          ],
      ),

      // 2. Body: Image + Text
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼️ Hero Image (The "Flying" Animation)
                  Hero(
                    tag: product.id, // Must match the tag in the previous screen
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.contain, // Keeps the image aspect ratio
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 📝 Details Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111618), // From your HTML
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Price
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF617F89), // Secondary color
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Color(0xFF111618),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. "Add to Cart" Sticky Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0F3F4))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addItem(product);

                  // 2️⃣ Show the feedback message
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hides old messages instantly
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${product.title} added to cart!"),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          // Optional: If you want to let them undo immediately
                          Provider.of<CartProvider>(context, listen: false).removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13B6EC), // 🎨 Your Cyan Color
                  foregroundColor: const Color(0xFF111618), // Text Color
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}