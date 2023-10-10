import 'package:budget_app/charts_page.dart';
import 'package:budget_app/get_cloud_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budget_app/summary_view.dart';
import 'package:budget_app/home_page.dart';

User? _user = FirebaseAuth.instance.currentUser;

class ExpenseHistory extends StatefulWidget {
  final Map groupedByDate;
  final String category;
  final VoidCallback triggerRefresh;
  final GlobalKey<Chart2State> chartsPageKey;

  const ExpenseHistory({
    super.key,
    required this.groupedByDate,
    required this.category,
    required this.triggerRefresh,
    required this.chartsPageKey,
  });

  @override
  State<ExpenseHistory> createState() => _ExpenseHistoryState();
}

class _ExpenseHistoryState extends State<ExpenseHistory> {
  void deleteItem(String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection("Expenses")
          .doc(_user!.uid)
          .collection("userExpenses")
          .doc(docID)
          .delete();
    } catch (e) {
      print("Expense not added");
    }
    print('BEFORE $expenseList');
    expenseList.removeWhere((item) => item['docID'] == docID);
    print('AFTER $expenseList');
    widget.triggerRefresh();
  }

  void subtractFromPieChart(String expCategory, String expValue){
    if(expCategory == "Shopping"){
      userExpenseByCategory[1] = (double.parse(userExpenseByCategory[1]) - double.parse(expValue)).toString();
    }
    else if(expCategory == "Groceries"){
      userExpenseByCategory[3] = (double.parse(userExpenseByCategory[3]) - double.parse(expValue)).toString();
    }
    else if(expCategory == "Cash Out"){
      userExpenseByCategory[5] = (double.parse(userExpenseByCategory[5]) - double.parse(expValue)).toString();
    }
    else if(expCategory == "Travel"){
      userExpenseByCategory[7] = (double.parse(userExpenseByCategory[7]) - double.parse(expValue)).toString();
    }
    else if(expCategory == "Entertainment"){
      userExpenseByCategory[9] = (double.parse(userExpenseByCategory[9]) - double.parse(expValue)).toString();
    }
    else if(expCategory == "Bills"){
      userExpenseByCategory[11] = (double.parse(userExpenseByCategory[11]) - double.parse(expValue)).toString();
    }
    else if(expCategory == "Other"){
      userExpenseByCategory[13] = (double.parse(userExpenseByCategory[13]) - double.parse(expValue)).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groupedByDate.isEmpty) {
      return const Text('You have not purchased anything in this category yet');
    }
    bool displayCategory;
    widget.category == 'All' ? displayCategory = true : displayCategory = false;
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.groupedByDate.length,
      itemBuilder: (context, index) {
        String date = widget.groupedByDate.keys.elementAt(index).toString();
        List itemsAtDate = widget.groupedByDate[date]!;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 20),
              child: Text(
                date,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itemsAtDate.length,
              itemBuilder: (context, index) {
                final item = itemsAtDate[index];
                return Card(
                  child: ListTile(
                    title: Text(item['description']),
                    subtitle: displayCategory ? Text(item['category']) : null,
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        '\$${item['value']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteItem(item['docID']);
                          subtractFromPieChart(item['category'], item['value']);
                          widget.chartsPageKey.currentState?.updateState();
                        },
                        splashRadius: 20,
                      )
                    ]),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
