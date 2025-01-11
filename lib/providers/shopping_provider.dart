import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/shopping_item.dart';

class ShoppingListProvider with ChangeNotifier {
  final Box<ShoppingItem> _shoppingBox = Hive.box<ShoppingItem>('shoppingBox');
  final Box _settingsBox = Hive.box('settings'); // صندوق جديد لحفظ الإعدادات
  double _budget = 0.0;

  ShoppingListProvider() {
    _loadBudget(); // تحميل الميزانية عند إنشاء الكائن
  }

  List<ShoppingItem> get items => _shoppingBox.values.toList();

  double get budget => _budget;

  void setBudget(double newBudget) {
    _budget = newBudget;
    _settingsBox.put('budget', _budget); // حفظ الميزانية في Hive
    notifyListeners();
  }

  void _loadBudget() {
    _budget = _settingsBox.get('budget', defaultValue: 0.0); // تحميل الميزانية من Hive
  }

  double get totalSpent => _shoppingBox.values.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get remainingBudget => _budget - totalSpent;

  bool isBudgetExceeded() {
    return totalSpent > _budget;
  }

  void addItem(String name, int quantity, String category, double price) {
    final item = ShoppingItem(
      id: DateTime.now().toString(),
      name: name,
      quantity: quantity,
      category: category,
      price: price,
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

  void removeAllItems() {
    _shoppingBox.clear(); // إزالة جميع العناصر
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

  List<ShoppingItem> getPurchasedItems() {
    return _shoppingBox.values.where((item) => item.isPurchased).toList();
  }

  List<ShoppingItem> getPendingItems() {
    return _shoppingBox.values.where((item) => !item.isPurchased).toList();
  }
}