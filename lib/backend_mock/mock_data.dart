import '../Model/product_model.dart';

class MockData {
  // This static list acts as your "Database"
  static List<Product> products = [
    Product(
      id: 'p1',
      title: 'Wireless Headphones',
      price: 59.99,
      description: 'High quality noise cancelling headphones.',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: 'p2',
      title: 'Smart Watch',
      price: 129.50,
      description: 'Tracks your heart rate and steps.',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    // ... add 10 more items here
  ];
}