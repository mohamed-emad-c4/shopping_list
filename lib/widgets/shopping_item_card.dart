import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shopping_item.dart';
import '../providers/shopping_provider.dart';

class ShoppingItemCard extends StatelessWidget {
  final ShoppingItem item;

  const ShoppingItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final totalPrice = item.price * item.quantity;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              item.isPurchased ? Colors.green.shade100 : Colors.blue.shade100,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: item.isPurchased ? Colors.green : Colors.blue,
            child: Icon(
              item.isPurchased ? Icons.check : Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration: item.isPurchased ? TextDecoration.lineThrough : null,
              color: item.isPurchased ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الكمية: ${item.quantity}'),
              Text('السعر: ${item.price.toStringAsFixed(2)} جنيه'),
              Text('الإجمالي: ${totalPrice.toStringAsFixed(2)} جنيه'),
              Text('الفئة: ${item.category}'),
            ],
          ),
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