import 'product_model.dart';

class CartManager {
  // 1. Private static instance
  static final CartManager _instance = CartManager._internal();

  // 2. Factory constructor returns the same instance every time
  factory CartManager() {
    return _instance;
  }

  CartManager._internal();

  // The actual data: A list of products currently in the cart
  final List<Product> _cartItems = [];

  // GETTER: To read the list (prevents direct modification from outside)
  List<Product> get items => _cartItems;

  // METHOD: Add item
  void addToCart(Product product) {
    _cartItems.add(product);
    print("${product.title} added to cart!");
  }

  // METHOD: Remove item
  void removeFromCart(Product product) {
    _cartItems.remove(product);
  }

  // METHOD: Calculate Total Price (OOP Logic)
  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.price;
    }
    return total;
  }
}