import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  // The private list of favorite products
  final List<Product> _wishlistItems = [];

  // Getter to access the list safely
  List<Product> get wishlistItems => _wishlistItems;

  // Check if a product is already a favorite
  bool isFavorite(Product product) {
    return _wishlistItems.any((item) => item.id == product.id);
  }

  // Toggle Logic: Add if not there, Remove if it is
  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      _wishlistItems.removeWhere((item) => item.id == product.id);
    } else {
      _wishlistItems.add(product);
    }
    // 🔔 Notify all listeners (Screens) to rebuild
    notifyListeners();
  }
}