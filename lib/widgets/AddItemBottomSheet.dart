import 'package:flutter/material.dart';

class AddItemBottomSheet extends StatelessWidget {
  final Function(String, int, String, double, String) onAddItem;

  const AddItemBottomSheet({super.key, required this.onAddItem});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCategory = 'فواكه';
    String selectedPriority = 'متوسط';

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
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
                      Navigator.of(context).pop();
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
                items: const [
                  DropdownMenuItem(value: 'فواكه', child: Text('فواكه')),
                  DropdownMenuItem(value: 'خضروات', child: Text('خضروات')),
                  DropdownMenuItem(value: 'مشروبات', child: Text('مشروبات')),
                  DropdownMenuItem(value: 'لحوم', child: Text('لحوم')),
                  DropdownMenuItem(value: 'أخرى', child: Text('أخرى')),
                ],
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'عاجل', child: Text('عاجل')),
                  DropdownMenuItem(value: 'متوسط', child: Text('متوسط')),
                  DropdownMenuItem(value: 'منخفض', child: Text('منخفض')),
                ],
                onChanged: (value) {
                  selectedPriority = value!;
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
                    onAddItem(name, quantity, selectedCategory, price, selectedPriority);
                    Navigator.of(context).pop();
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
  }
}