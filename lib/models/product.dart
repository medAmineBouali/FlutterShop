class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      // ⚠️ API prices can be Integers (10) or Doubles (10.99), so we handle both:
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      imageUrl: json['image'], // FakeStoreAPI uses "image", not "imageUrl"
    );
  }
}