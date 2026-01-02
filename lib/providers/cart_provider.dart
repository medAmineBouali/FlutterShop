import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  // We use a Map to easily find items by their Product ID
  final Map<int, CartItem> _items = {};

  // Getter to return items as a List (for the UI to build)
  List<CartItem> get items => _items.values.toList();

  // Getter for total item count (e.g., 5 items in cart)
  int get itemCount => _items.length;

  // Getter for Grand Total $$$
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalLinePrice;
    });
    return total;
  }

  // 1️⃣ Add to Cart Logic
  void addItem(Product product) {
    print("ADDING TO CART: ${product.title}");
    if (_items.containsKey(product.id)) {
      // If item exists, just increase quantity
      _items.update(
        product.id,
            (existingItem) => CartItem(
          id: existingItem.id,
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      // If new, add it to the map
      _items.putIfAbsent(
        product.id,
            () => CartItem(
          id: DateTime.now().toString(), // Unique ID for the cart entry
          product: product,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  // 2️⃣ Remove Single Item (Logic for '-' button)
  void removeSingleItem(int productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
            (existingItem) => CartItem(
          id: existingItem.id,
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // 3️⃣ Delete completely (Optional garbage can icon)
  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // 4️⃣ Clear Cart (For checkout)
  void clear() {
    _items.clear();
    notifyListeners();
  }
}