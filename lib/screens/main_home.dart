import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shopping_item.dart';
import '../providers/shopping_provider.dart';
import '../widgets/AddItemBottomSheet.dart';
import '../widgets/BudgetWarningWidget.dart';
import '../widgets/SearchAndSortWidget.dart';
import '../widgets/ShoppingAppBar.dart';
import '../widgets/ShoppingItemList.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  String _selectedSortOption = 'الأولوية';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);

    List<ShoppingItem> items = _searchQuery.isEmpty
        ? shoppingListProvider.items
        : shoppingListProvider.searchItems(_searchQuery);

    switch (_selectedSortOption) {
      case 'الأولوية':
        items = shoppingListProvider.sortItemsByPriority(items);
        break;
      case 'السعر':
        items = shoppingListProvider.sortItemsByPrice(items);
        break;
      case 'الكمية':
        items = shoppingListProvider.sortItemsByQuantity(items);
        break;
      case 'الفئة':
        items = shoppingListProvider.sortItemsByCategory(items);
        break;
    }

    final filteredItems = _selectedCategory == 'الكل'
        ? items
        : items.where((item) => item.category == _selectedCategory).toList();

    final isBudgetExceeded = shoppingListProvider.isBudgetExceeded();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('قائمة التسوق', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  if (shoppingListProvider.budget > 0)
                    Text(
                      'المتبقي: ${shoppingListProvider.remainingBudget.toStringAsFixed(2)} جنيه',
                      style: TextStyle(
                        fontSize: 14,
                        color: isBudgetExceeded ? Colors.red : Colors.green,
                      ),
                    ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete, size: 28),
                  onPressed: () => _showDeleteAllDialog(context),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_money, size: 28),
                  onPressed: () => _showSetBudgetDialog(context),
                ),
              ],
              pinned: true, // يثبت الـ AppBar عند التمرير
              floating: true, // يظهر الـ AppBar عند التمرير لأعلى
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(icon: Icon(Icons.pending), text: 'المعلقة'),
                  Tab(icon: Icon(Icons.check_circle), text: 'المشتراة'),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: [
            BudgetWarningWidget(isBudgetExceeded: isBudgetExceeded),
            SearchAndSortWidget(
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              selectedSortOption: _selectedSortOption,
              onSortOptionChanged: (value) => setState(() => _selectedSortOption = value),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ShoppingItemList(items: filteredItems.where((item) => !item.isPurchased).toList()),
                  ShoppingItemList(items: filteredItems.where((item) => item.isPurchased).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => AddItemBottomSheet(
            onAddItem: (name, quantity, category, price, priority) {
              shoppingListProvider.addItem(name, quantity, category, price, priority: priority);
            },
          ),
        ),
        child: const Icon(Icons.add, size: 30),
        backgroundColor: Colors.blue,
        elevation: 6,
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('حذف جميع العناصر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: const Text('هل أنت متأكد من حذف جميع العناصر؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ShoppingListProvider>(context, listen: false).removeAllItems();
                Navigator.of(ctx).pop();
              },
              child: const Text('حذف', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showSetBudgetDialog(BuildContext context) {
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('تعيين الميزانية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: budgetController,
            decoration: InputDecoration(
              labelText: 'الميزانية',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                final budget = double.tryParse(budgetController.text) ?? 0.0;
                Provider.of<ShoppingListProvider>(context, listen: false).setBudget(budget);
                Navigator.of(ctx).pop();
              },
              child: const Text('حفظ', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}