import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:budget_app/expense_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'category.dart';
import 'category_widget.dart';
import 'charts_page.dart';

var expenseList = [];
double totalExpense = 0.0;

bool listShown = false;

Map<dynamic, List<dynamic>> groupedByDate = {};
Map<dynamic, List<dynamic>> groupedByCategory = {};
Map<dynamic, List<dynamic>> groupedByCategoryDate = {};
Map<String, double> totalExpensesByCategory = {};
// var groupedByDate = groupBy(expenseList, (item) => item['date']);
// var groupedByCategoryDate = groupedByDate;

void getExpenseList() async {
  User? _user = FirebaseAuth.instance.currentUser;
  try {
    CollectionReference userExpensesCollection = FirebaseFirestore.instance
        .collection("Expenses")
        .doc(_user!.uid)
        .collection("userExpenses");
    QuerySnapshot userExpensesSnapshot = await userExpensesCollection.get();
    for (QueryDocumentSnapshot document in userExpensesSnapshot.docs) {
      // print('Document ID: ${document.id}, Data: ${document.data()}');

      Map<String, dynamic> expense = document.data() as Map<String, dynamic>;
      // print(expense['category']);
      // print(expense['value']);
      // print(expense['date']);
      expenseList.add({
        "docID": document.id,
        "category": expense['category'],
        "value": expense['value'],
        "date": expense['date'],
        "description": expense['description']
      });
    }
    print(expenseList);
    groupedByDate = groupBy(expenseList, (item) => item['date']);
    groupedByCategory = groupBy(expenseList, (item) => ['category']);
    print("Documents successfully retrieved");
  } catch (e) {
    print("Documents not retrieved");
  }
}

void clearExpenseList() {
  expenseList.clear();
  print(expenseList);
}

class SummaryView extends StatefulWidget {
  final GlobalKey<Chart2State> chartsPageKey;
  const SummaryView({super.key, required this.chartsPageKey});
  // Home() {
  //   getExpenseList(); // option 1. to call the function only when the class is instantiated
  // }

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  String? _dropdownValue = 'All';

  List<Category> categories = Category.categoryList;

  void dropdownCallback(String? selectedValue) {
    setState(() {
      _dropdownValue = selectedValue;

      if (_dropdownValue != 'All') {
        if (groupedByCategoryDate[_dropdownValue] == null) {
          groupedByCategoryDate = {};
        } else {
          groupedByCategoryDate = groupBy(
              groupedByCategory[_dropdownValue]!, (item) => item['date']);
        }
      }
    });
  }

  void buttonCallback() {
    // getExpenseList();
    // groupedByDate = groupBy(expenseList, (item) => item['date']);
    // groupedByCategoryDate = groupedByDate;
    print("GROUP BY DATE:");
    print(groupedByDate);
    setState(() {
      listShown ? listShown = false : listShown = true;
    });
  }

  void setListShownFalse() {
    setState(() {
      listShown = false;
    });
  }

  void _refreshView() {
    groupedByDate = groupBy(expenseList, (item) => item['date']);
    groupedByCategory = groupBy(expenseList, (item) => ['category']);
    dropdownCallback(_dropdownValue);
  }

  void updateTotalExpense() {
    double newTotalExpense = 0.0;
    for (var expense in expenseList) {
      double value = double.parse(expense['value'] ?? "0.0");
      newTotalExpense += value;
    }

    setState(() {
      totalExpense = newTotalExpense;
    });
  }

  void updateCurrentExpense() {
    totalExpensesByCategory = {};

    for (var expense in expenseList) {
      String category = expense['category'];
      double expenseAmount = double.parse(expense['value'] ?? "0.0");
      totalExpensesByCategory[category] =
          (totalExpensesByCategory[category] ?? 0.0) + expenseAmount;
    }

    for (Category category in Category.categoryList) {
      double totalExpenseForCategory =
          totalExpensesByCategory[category.name] ?? 0.0;
      category.updateCurrentExpense(totalExpenseForCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    _refreshView();
    updateTotalExpense();
    updateCurrentExpense();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total Expense: \$${totalExpense.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryWidget(
                    category: categories[index],
                  );
                },
              ),
            ],
          ),
        ),
        ElevatedButton(
          child: const Text('Transactions'),
          onPressed: () {
            buttonCallback();
          },
        ),
        Visibility(
          visible: listShown,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: DropdownButton(
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(
                        value: 'Shopping', child: Text('Shopping')),
                    DropdownMenuItem(
                        value: 'Groceries', child: Text('Groceries')),
                    DropdownMenuItem(
                        value: 'Cash Out', child: Text('Cash Out')),
                    DropdownMenuItem(value: 'Travel', child: Text('Travel')),
                    DropdownMenuItem(
                        value: 'Entertainment', child: Text('Entertainment')),
                    DropdownMenuItem(value: 'Bills', child: Text('Bills')),
                    DropdownMenuItem(value: 'Other', child: Text('Other'))
                  ],
                  value: _dropdownValue,
                  onChanged: dropdownCallback,
                ),
              ),
              Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.2),
                child: _dropdownValue != 'All'
                    ? ExpenseHistory(
                        groupedByDate: groupedByCategoryDate,
                        category: _dropdownValue.toString(),
                        triggerRefresh: _refreshView,
                        chartsPageKey: widget.chartsPageKey,
                      )
                    : ExpenseHistory(
                        groupedByDate: groupedByDate,
                        category: _dropdownValue.toString(),
                        triggerRefresh: _refreshView,
                        chartsPageKey: widget.chartsPageKey,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
