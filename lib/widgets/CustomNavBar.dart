import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  // 1. Define your tabs here so it's easy to change later
  final List<Map<String, dynamic>> _navItems = [
    {"icon": Icons.home_filled, "label": "Home"},
    {"icon": Icons.search, "label": "Explore"},
    {"icon": Icons.favorite_border, "label": "Wishlist"},
    {"icon": Icons.shopping_cart_outlined, "label": "Cart"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // Floating margins
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      decoration: BoxDecoration(
        color: Colors.black, // Dark Bar Background
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_navItems.length, (index) {
          return _buildNavItem(index);
        }),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Smooth animation
        curve: Curves.easeInOut,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // 2. The Active Tab Background (Dark Orange)
          color: isSelected ? Colors.deepOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(
              _navItems[index]["icon"],
              // 3. Icon Color: White when selected, Grey when unselected
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            // 4. Only show text if selected
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  _navItems[index]["label"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}