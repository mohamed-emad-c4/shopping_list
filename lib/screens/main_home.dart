import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';
import '../widgets/shopping_item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  late TabController _tabController;

  final List<String> categories = [
    'الكل',
    'فواكه',
    'خضروات',
    'مشروبات',
    'لحوم',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);

    final items = _searchQuery.isEmpty
        ? shoppingListProvider.items
        : shoppingListProvider.searchItems(_searchQuery);

    final filteredItems = _selectedCategory == 'الكل'
        ? items
        : items.where((item) => item.category == _selectedCategory).toList();

    final isBudgetExceeded = shoppingListProvider.isBudgetExceeded();

    return Scaffold(
      appBar: AppBar(
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
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.pending), text: 'المعلقة'),
            Tab(icon: Icon(Icons.check_circle), text: 'المشتراة'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (isBudgetExceeded)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red,
              child: const Center(
                child: Text(
                  'لقد تجاوزت الميزانية المحددة!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'بحث',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredItems.where((item) => !item.isPurchased).length,
                  itemBuilder: (ctx, index) {
                    final item = filteredItems.where((item) => !item.isPurchased).toList()[index];
                    return ShoppingItemCard(item: item);
                  },
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredItems.where((item) => item.isPurchased).length,
                  itemBuilder: (ctx, index) {
                    final item = filteredItems.where((item) => item.isPurchased).toList()[index];
                    return ShoppingItemCard(item: item);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemBottomSheet(context),
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
                Provider.of<ShoppingListProvider>(context, listen: false)
                    .setBudget(budget);
                Navigator.of(ctx).pop();
              },
              child: const Text('حفظ', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showAddItemBottomSheet(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCategory = 'فواكه';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إضافة عنصر جديد',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'اسم العنصر',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: quantityController,
                    decoration: InputDecoration(
                      labelText: 'الكمية',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'السعر',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: categories
                        .where((category) => category != 'الكل')
                        .map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameController.text;
                      final quantity = int.tryParse(quantityController.text) ?? 0;
                      final price = double.tryParse(priceController.text) ?? 0.0;
                      if (name.isEmpty || quantity <= 0 || price <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('يرجى إدخال بيانات صحيحة!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        Provider.of<ShoppingListProvider>(context, listen: false)
                            .addItem(name, quantity, selectedCategory, price);
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('تمت إضافة العنصر بنجاح!'),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        );
                      }
                    },
                    child: const Text('إضافة', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}