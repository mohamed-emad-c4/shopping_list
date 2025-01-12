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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // تحديد لون الأولوية
    Color priorityColor;
    switch (item.priority) {
      case "عاجل":
        priorityColor = const Color(0xFFEF5350); // أحمر
        break;
      case "متوسط":
        priorityColor = const Color(0xFFFFA726); // برتقالي
        break;
      case "منخفض":
        priorityColor = const Color(0xFF66BB6A); // أخضر
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // إضافة تفاعل عند النقر (اختياري)
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // أيقونة العنصر
              Icon(
                item.isPurchased ? Icons.check_circle : Icons.shopping_cart,
                color: item.isPurchased ? const Color(0xFF66BB6A) : const Color(0xFF42A5F5),
                size: 24,
              ),
              const SizedBox(width: 12),
              // تفاصيل العنصر
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الكمية: ${item.quantity} | السعر: ${item.price.toStringAsFixed(2)} جنيه',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[300] : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الإجمالي: ${totalPrice.toStringAsFixed(2)} جنيه',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[300] : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              // الأولوية والأيقونات
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.priority,
                      style: TextStyle(
                        fontSize: 12,
                        color: priorityColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Color(0xFFEF5350)),
                        onPressed: () {
                          Provider.of<ShoppingListProvider>(context, listen: false)
                              .removeItem(item.id);
                        },
                      ),
                      Checkbox(
                        value: item.isPurchased,
                        onChanged: (_) {
                          Provider.of<ShoppingListProvider>(context, listen: false)
                              .togglePurchasedStatus(item.id);
                        },
                        activeColor: const Color(0xFF66BB6A),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}