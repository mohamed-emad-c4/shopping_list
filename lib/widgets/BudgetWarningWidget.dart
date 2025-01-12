import 'package:flutter/material.dart';

class BudgetWarningWidget extends StatelessWidget {
  final bool isBudgetExceeded;

  const BudgetWarningWidget({super.key, required this.isBudgetExceeded});

  @override
  Widget build(BuildContext context) {
    return isBudgetExceeded
        ? Container(
            padding: const EdgeInsets.all(8),
            color: Colors.red,
            child: const Center(
              child: Text(
                'لقد تجاوزت الميزانية المحددة!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}