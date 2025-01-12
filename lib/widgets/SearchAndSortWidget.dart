import 'package:flutter/material.dart';

class SearchAndSortWidget extends StatelessWidget {
  final Function(String) onSearchChanged;
  final String selectedSortOption;
  final Function(String) onSortOptionChanged;

  const SearchAndSortWidget({
    super.key,
    required this.onSearchChanged,
    required this.selectedSortOption,
    required this.onSortOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'بحث',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onChanged: onSearchChanged,
              ),
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: selectedSortOption,
            items: const [
              DropdownMenuItem(value: 'الأولوية', child: Text('الأولوية')),
              DropdownMenuItem(value: 'السعر', child: Text('السعر')),
              DropdownMenuItem(value: 'الكمية', child: Text('الكمية')),
              DropdownMenuItem(value: 'الفئة', child: Text('الفئة')),
            ],
            onChanged: (value) {
              if (value != null) {
                onSortOptionChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}