import 'package:hive/hive.dart';

part 'shopping_item.g.dart';

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

  @HiveField(4)
  final String category;

  @HiveField(5)
  final double price; // إضافة حقل السعر

  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.isPurchased = false,
    required this.category,
    required this.price, // إضافة السعر كحقل مطلوب
  });
}