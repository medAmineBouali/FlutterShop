import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import 'order_success_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Check if we can pop (e.g. came from Detail page)
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // If on main tabs, maybe show a snackbar or do nothing
              // (The user can just tap another tab)
            }
          },
        ),
      ),
      // 🧠 CONSUMER: Listens to changes in the CartProvider
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          final items = cart.items;

          return Column(
            children: [
              // 📦 List of Items
              Expanded(
                child: items.isEmpty
                    ? _buildEmptyCart()
                    : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 16),
                  itemBuilder: (ctx, i) {
                    // Get the specific item
                    final cartItem = items[i];
                    return _buildCartItem(cart, cartItem);
                  },
                ),
              ),

              // 💵 Price Summary Section (Only show if cart has items)
              if (items.isNotEmpty) _buildSummarySection(context, cart),
            ],
          );
        },
      ),
    );
  }

  // 1️⃣ Widget for a Single Row Item
  Widget _buildCartItem(CartProvider cart, CartItem cartItem) {
    return Row(
      children: [
        // Image
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
            image: DecorationImage(
              image: NetworkImage(cartItem.product.imageUrl),
              fit: BoxFit.cover, // Keeps image proportional
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Title & Price
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItem.product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                "\$${cartItem.product.price.toStringAsFixed(2)}",
                style: const TextStyle(color: Color(0xFF617F89)), // Muted Blue-Grey
              ),
            ],
          ),
        ),

        // Quantity Controls
        Row(
          children: [
            // Decrease Button (-)
            _buildQtyButton(Icons.remove, () {
              cart.removeSingleItem(cartItem.product.id);
            }),

            // Quantity Number
            SizedBox(
              width: 32,
              child: Text(
                "${cartItem.quantity}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            // Increase Button (+)
            _buildQtyButton(Icons.add, () {
              cart.addItem(cartItem.product);
            }),
          ],
        ),
      ],
    );
  }

  // 2️⃣ Widget for Price Summary & Checkout
  Widget _buildSummarySection(BuildContext context, CartProvider cart) {
    final subtotal = cart.totalAmount;
    final tax = subtotal * 0.10; // 10% Tax
    final total = subtotal + tax;

    return Container(
      // Added bottom padding (100) to account for the floating navigation bar
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F3F4))),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Price Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow("Subtotal", subtotal),
          const SizedBox(height: 8),
          _buildSummaryRow("Tax (10%)", tax),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  // 1. Clear the cart logic
                  cart.clear();
                  // 2. Navigate to Success Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
                  );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13B6EC), // 🎨 Cyan Blue
                foregroundColor: const Color(0xFF111618), // Text Color
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Checkout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // 3️⃣ Helper for Empty State
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text("Your cart is empty", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 4️⃣ Helper for +/- Buttons
  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3F4), // Light Gray
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF111618)),
      ),
    );
  }

  // 5️⃣ Helper for Summary Text Rows
  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF617F89), fontSize: 14)),
        Text("\$${amount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
