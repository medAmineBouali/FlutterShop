import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  // Helper to calculate total price for this specific row (Price * Qty)
  double get totalLinePrice => product.price * quantity;
}