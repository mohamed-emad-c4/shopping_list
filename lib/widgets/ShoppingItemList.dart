import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/shopping_item_card.dart';

import '../models/shopping_item.dart';

class ShoppingItemList extends StatelessWidget {
  final List<ShoppingItem> items;

  const ShoppingItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        return ShoppingItemCard(item: item);
      },
    );
  }
}