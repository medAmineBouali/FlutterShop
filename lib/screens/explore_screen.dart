import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../widgets/product_horizontal_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService apiService = ApiService();

  // State for Data
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  // State for UI
  String _searchQuery = "";
  String _selectedSort = "Relevance"; // Default sort

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final products = await apiService.fetchProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // 🧠 The "Data Engineer" Logic: Filter & Sort
  void _filterAndSort() {
    List<Product> temp = _allProducts.where((p) {
      return p.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_selectedSort == "Price: Low to High") {
      temp.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == "Price: High to Low") {
      temp.sort((a, b) => b.price.compareTo(a.price));
    }

    setState(() {
      _filteredProducts = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Explore"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Goes back if pushed
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F3F4), // 🎨 Input Background
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) {
                  _searchQuery = value;
                  _filterAndSort();
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFF617F89)),
                  hintText: "Search products...",
                  hintStyle: TextStyle(color: Color(0xFF617F89)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🏷️ Sort Chips
            const Text("Sort by", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip("Relevance"),
                  _buildSortChip("Price: Low to High"),
                  _buildSortChip("Price: High to Low"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📦 Product List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProducts.isEmpty
                  ? const Center(child: Text("No products found"))
                  : ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductHorizontalCard(product: _filteredProducts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(String label) {
    bool isSelected = _selectedSort == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSort = label;
            _filterAndSort();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : const Color(0xFFF0F3F4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF111618),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}