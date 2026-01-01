import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
           Consumer<WishlistProvider>(
              builder: (context, provider, child) {
                bool isFav = provider.isFavorite(product);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    provider.toggleFavorite(product);
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
            const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image
                  Center(
                    child: Hero(
                      tag: product.id,
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // 2. Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${product.price} €",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 3. Action Bar (Rounded container)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(icon: Icons.store, label: "Store", isDark: true),
                        _buildActionButton(icon: Icons.remove_shopping_cart, label: "Remove"),
                        _buildActionButton(icon: Icons.remove_red_eye_outlined, label: "Catalog"),
                        _buildActionButton(icon: Icons.share_outlined, label: "Share"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: const [
                            Text("Show more", style: TextStyle(color: Colors.grey)),
                            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey)
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // 5. "Add to Cart" Button (Dark Orange)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                   Provider.of<CartProvider>(context, listen: false).addItem(product);
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${product.title} added to cart!"), duration: const Duration(seconds: 1)),
                   );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange, // Dark Orange
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, bool isDark = false}) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.white : Colors.black,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
