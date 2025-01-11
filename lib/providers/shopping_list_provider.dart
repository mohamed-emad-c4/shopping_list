import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/shopping_item.dart';

class ShoppingListProvider with ChangeNotifier {
  final Box<ShoppingItem> _shoppingBox = Hive.box<ShoppingItem>('shoppingBox');

  List<ShoppingItem> get items {
    return _shoppingBox.values.toList();
  }

  void addItem(String name, int quantity, String category) {
    final item = ShoppingItem(
      id: DateTime.now().toString(),
      name: name,
      quantity: quantity,
      category: category, // إضافة الفئة
    );
    _shoppingBox.put(item.id, item);
    notifyListeners();
  }

  void togglePurchasedStatus(String id) {
    final item = _shoppingBox.get(id);
    if (item != null) {
      item.isPurchased = !item.isPurchased;
      _shoppingBox.put(id, item);
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _shoppingBox.delete(id);
    notifyListeners();
  }

  List<ShoppingItem> searchItems(String query) {
    return _shoppingBox.values
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<ShoppingItem> getItemsByCategory(String category) {
    return _shoppingBox.values
        .where((item) => item.category == category)
        .toList();
  }
}