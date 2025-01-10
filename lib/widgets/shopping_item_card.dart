import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';
import '../models/shopping_item.dart';

class ShoppingItemCard extends StatelessWidget {
  final ShoppingItem item;

  const ShoppingItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        Provider.of<ShoppingListProvider>(context, listen: false)
            .removeItem(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف العنصر بنجاح!'),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        elevation: 3,
        child: ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: Text(item.name),
          subtitle: Text('الكمية: ${item.quantity}'),
          trailing: Checkbox(
            value: item.isPurchased,
            onChanged: (_) {
              Provider.of<ShoppingListProvider>(context, listen: false)
                  .togglePurchasedStatus(item.id);
            },
          ),
        ),
      ),
    );
  }
}