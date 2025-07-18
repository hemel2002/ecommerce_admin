import 'package:flutter/material.dart';

class CategoryTableHeader extends StatelessWidget {
  const CategoryTableHeader({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.searchController,
    this.searchOnChanged,
  });

  final VoidCallback onPressed;
  final String buttonText;
  final TextEditingController searchController;
  final Function(String)? searchOnChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          // Button - Full width
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(buttonText),
            ),
          ),

          const SizedBox(height: 16),

          // Search Field - Full width
          TextFormField(
            controller: searchController,
            onChanged: searchOnChanged,
            decoration: const InputDecoration(
              hintText: 'Search categories...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }
}
