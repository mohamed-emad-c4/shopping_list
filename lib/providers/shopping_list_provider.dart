import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/shopping_item.dart';

class ShoppingListProvider with ChangeNotifier {
  final Box<ShoppingItem> _shoppingBox = Hive.box<ShoppingItem>('shoppingBox');

  List<ShoppingItem> get items {
    return _shoppingBox.values.toList();
  }

  void addItem(String name, int quantity) {
    final item = ShoppingItem(
      id: DateTime.now().toString(),
      name: name,
      quantity: quantity,
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
  final results = _shoppingBox.values
      .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
  print('نتائج البحث: $results'); // طباعة النتائج للتأكد من صحتها
  return results;
}
List<ShoppingItem> sortItems(bool sortByPurchased) {
  return _shoppingBox.values.toList()
    ..sort((a, b) {
      if (sortByPurchased) {
        return a.isPurchased == b.isPurchased ? 0 : a.isPurchased ? 1 : -1;
      } else {
        return a.isPurchased == b.isPurchased ? 0 : b.isPurchased ? 1 : -1;
      }
    });
}
List<ShoppingItem> displayItems(String query) {
  final allItems = _shoppingBox.values.toList();

  if (query.isEmpty) {
    return allItems; // إذا كان البحث فارغًا، نعرض جميع العناصر
  }

  // فصل العناصر التي تطابق البحث عن العناصر الأخرى
  final matchedItems = allItems
      .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

  final unmatchedItems = allItems
      .where((item) => !item.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

  // دمج العناصر التي تطابق البحث أولًا، ثم العناصر الأخرى
  return [...matchedItems, ...unmatchedItems];
}
}