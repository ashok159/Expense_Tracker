import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> userExpenseByCategory = [
  "Shopping",
  "0.00",
  "Groceries",
  "0.00",
  "Cash out",
  "0.00",
  "Travel",
  "0.00",
  "Entertainment",
  "0.00",
  "Bills",
  "0.00",
  "Other",
  "0.00",
];

Future<void> getExpenseByCategory() async {
  User? curUser = FirebaseAuth.instance.currentUser;

  try {
    CollectionReference userExpensesCollection = FirebaseFirestore.instance
        .collection("Expenses")
        .doc(curUser!.uid)
        .collection("userExpenses");
    QuerySnapshot userExpensesSnapshot = await userExpensesCollection.get();
    for (QueryDocumentSnapshot document in userExpensesSnapshot.docs) {
      Map<String, dynamic> expense = document.data() as Map<String, dynamic>;
      if (expense['category'] == "Shopping") {
        userExpenseByCategory[1] = (double.parse(userExpenseByCategory[1]) +
                double.parse(expense['value']))
            .toString();
      } else if (expense['category'] == "Groceries") {
        userExpenseByCategory[3] = (double.parse(userExpenseByCategory[3]) +
                double.parse(expense['value']))
            .toString();
      } else if (expense['category'] == "Cash Out") {
        userExpenseByCategory[5] = (double.parse(userExpenseByCategory[5]) +
                double.parse(expense['value']))
            .toString();
      } else if (expense['category'] == "Travel") {
        userExpenseByCategory[7] = (double.parse(userExpenseByCategory[7]) +
                double.parse(expense['value']))
            .toString();
      } else if (expense['category'] == "Entertainment") {
        userExpenseByCategory[9] = (double.parse(userExpenseByCategory[9]) +
                double.parse(expense['value']))
            .toString();
      } else if (expense['category'] == "Bills") {
        userExpenseByCategory[11] = (double.parse(userExpenseByCategory[11]) +
                double.parse(expense['value']))
            .toString();
      } else if (expense['category'] == "Other") {
        userExpenseByCategory[13] = (double.parse(userExpenseByCategory[13]) +
                double.parse(expense['value']))
            .toString();
      }
    }
    print("Documents successfully retrieved");
    /* userExpenseByCategory.forEach((element) {
      print(element);
    }); */
  } catch (e) {
    print("Documents not retrieved");
  }
}

void dumpUserExpenseByCategory() {
  userExpenseByCategory = [
    "Shopping",
    "0.00",
    "Groceries",
    "0.00",
    "Cash out",
    "0.00",
    "Travel",
    "0.00",
    "Entertainment",
    "0.00",
    "Bills",
    "0.00",
    "Other",
    "0.00",
  ];
}
