import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../models/product.dart';
import 'detail_screen.dart'; // To navigate when clicking an item

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 👂 Listen to the provider
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final items = wishlistProvider.wishlistItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFC),
      appBar: AppBar(
        title: const Text("Wishlist"),
        backgroundColor: const Color(0xFFF8FBFC),
        elevation: 0,
        centerTitle: true,
      ),
      // 🧠 Conditional Logic: Empty vs. List
      body: items.isEmpty
          ? _buildEmptyState(context)
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75, // Adjusts height of cards
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final product = items[index];
            return _buildWishlistCard(context, product, wishlistProvider);
          },
        ),
      ),
    );
  }

  // 🃏 The Card Widget (Matches your screenshot)
  Widget _buildWishlistCard(BuildContext context, Product product, WishlistProvider provider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(product: product)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                // Image
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Remove Button (Optional, but good UX)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => provider.toggleFavorite(product),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0D181B),
            ),
          ),
          // Your screenshot didn't show price, but you can uncomment this if needed:
          // Text("\$${product.price}", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // ... (Keep your existing _buildEmptyState method here)
  Widget _buildEmptyState(BuildContext context) {
    // Paste your previous empty state code here...
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text("No favorites yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}