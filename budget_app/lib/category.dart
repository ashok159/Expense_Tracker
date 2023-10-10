class Category {
  final String name;
  double currentExpense;

  Category({required this.name, this.currentExpense = 0.0});

  void updateCurrentExpense(double newExpense) {
    currentExpense = newExpense;
  }

  static List<Category> categoryList = [
    Category(name: 'Shopping'),
    Category(name: 'Groceries'),
    Category(name: 'Cash Out'),
    Category(name: 'Travel'),
    Category(name: 'Entertainment'),
    Category(name: 'Bills'),
    Category(name: 'Other'),
  ];
}
