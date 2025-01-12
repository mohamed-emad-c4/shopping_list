import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';

class ShoppingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ShoppingListProvider shoppingListProvider;
  final TabController tabController;

  const ShoppingAppBar({
    super.key,
    required this.shoppingListProvider,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final isBudgetExceeded = shoppingListProvider.isBudgetExceeded();

    return AppBar(
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
      bottom: TabBar(
        controller: tabController,
        indicatorColor: Colors.white,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        tabs: const [
          Tab(icon: Icon(Icons.pending), text: 'المعلقة'),
          Tab(icon: Icon(Icons.check_circle), text: 'المشتراة'),
        ],
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50);
}