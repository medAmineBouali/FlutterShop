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
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: items.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 20),
                  itemBuilder: (ctx, i) {
                    final cartItem = items[i];
                    // Wrap with Dismissible for the swipe-to-delete effect (red background with trash icon)
                    return Dismissible(
                      key: ValueKey(cartItem.product.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE5E5), // Light Red background
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
                      ),
                      onDismissed: (direction) {
                        cart.removeSingleItem(cartItem.product.id); 
                      },
                      child: _buildCartItemCard(cart, cartItem),
                    );
                  },
                ),
              ),

              // 💵 Price Summary Section
              if (items.isNotEmpty) _buildSummarySection(context, cart),
            ],
          );
        },
      ),
    );
  }

  // 1️⃣ Widget for the Cart Item Card (New Design)
  Widget _buildCartItemCard(CartProvider cart, CartItem cartItem) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Adding a subtle shadow/border to mimic the "floating" card look
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image in a rounded square
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(
              cartItem.product.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Edit Icon (Edit icon removed as requested)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cartItem.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    // Removed Edit Pen Icon
                  ],
                ),
                
                const SizedBox(height: 4),
                // Time/Date placeholder (from image "02.01-07.01")
                Row(
                  children: const [
                    Icon(Icons.access_time, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("02.01-07.01", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Quantity and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Pill
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        children: [
                          _buildQtyBtn(Icons.remove, () {
                            cart.removeSingleItem(cartItem.product.id);
                          }),
                          SizedBox(
                            width: 30,
                            child: Text(
                              "${cartItem.quantity}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          _buildQtyBtn(Icons.add, () {
                            cart.addItem(cartItem.product);
                          }),
                        ],
                      ),
                    ),
                    
                    // Price
                    Text(
                      "${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)} €",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // White circle inside the pill
        ),
        child: Icon(icon, size: 16, color: Colors.black),
      ),
    );
  }

  // 2️⃣ Widget for Price Summary & Checkout
  Widget _buildSummarySection(BuildContext context, CartProvider cart) {
    final subtotal = cart.totalAmount;
    final tax = subtotal * 0.10; // 10% Tax
    final total = subtotal + tax;

    return Container(
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
                  cart.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
                  );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange, // Dark Orange
                foregroundColor: Colors.white, // Text Color (White for contrast)
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
