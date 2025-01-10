import 'package:hive/hive.dart';

part 'shopping_item.g.dart'; // سيتم إنشاء هذا الملف تلقائيًا

@HiveType(typeId: 0)
class ShoppingItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  bool isPurchased;

  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.isPurchased = false,
  });
}