import 'package:flutter/material.dart';
import 'category.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({required this.category});

  @override
  Widget build(BuildContext context) {
    double currentExpense = category.currentExpense;
    String categoryName = category.name;

    return ListTile(
      title: Text(categoryName),
      subtitle: Text('Current Expense: \$${currentExpense.toStringAsFixed(2)}'),
    );
  }
}
