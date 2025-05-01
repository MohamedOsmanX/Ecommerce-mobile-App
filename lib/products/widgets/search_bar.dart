import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool isGridView;
  final VoidCallback onViewToggle;

  const ProductSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.isGridView,
    required this.onViewToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: onViewToggle,
            tooltip: isGridView ? 'Show as list' : 'show as grid',
          ),
        ],
      ),
    );
  }
}
