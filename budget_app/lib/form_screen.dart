import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budget_app/summary_view.dart';
import 'package:budget_app/get_cloud_data.dart';

const List<String> list = <String>[
  'Pick Category',
  'Shopping',
  'Groceries',
  'Cash Out',
  'Travel',
  'Entertainment',
  'Bills',
  'Other'
];

class FormScreen extends StatefulWidget {
  final Function updateState;

  const FormScreen({super.key, required this.updateState});
  @override
  State<FormScreen> createState() => _FormScreenState();
}

String? _value;
String? _category;
String? _date;
String? _description;
String? _selectedDropdownValue = "Other";
DateTime now = new DateTime.now();
DateTime date = new DateTime(now.year, now.month, now.day);
User? _user = FirebaseAuth.instance.currentUser;

class _FormScreenState extends State<FormScreen> {
  TextEditingController _dateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildValue() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Value"),
      keyboardType: TextInputType.number,
      validator: (String? input) {
        if (input == null || input.isEmpty) {
          return "Value is required.";
        }
        double? value = double.tryParse(input);
        if (value == null || value <= 0) {
          return "Value must be a positive number.";
        }
        return null;
      },
      onSaved: (String? input) {
        if (input != null) {
          _value = input;
        }
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Description"),
      validator: (String? input) {
        if (input == null || input.isEmpty) {
          return "Value is required.";
        }
      },
      onSaved: (String? input) {
        if (input != null) {
          _description = input;
        }
      },
    );
  }

  Widget _buildCategory() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Category"),
      maxLength: 25,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Category is Required";
        }
      },
      onSaved: (String? value) {
        if (value != null) {
          _category = value;
        }
      },
    );
  }

  Widget _buildDate() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Date"),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Date is Required";
        }
      },
      onSaved: (String? value) {
        if (value != null) {
          _date = value;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // ElevatedButton(
                  //     child: Text("Get Documents"),
                  //     onPressed: () async {
                  //       try {
                  //         CollectionReference userExpensesCollection =
                  //             FirebaseFirestore.instance
                  //                 .collection("Expenses")
                  //                 .doc(_user!.uid)
                  //                 .collection("userExpenses");
                  //         QuerySnapshot userExpensesSnapshot =
                  //             await userExpensesCollection.get();
                  //         for (QueryDocumentSnapshot document
                  //             in userExpensesSnapshot.docs) {
                  //           print(
                  //               'Document ID: ${document.id}, Data: ${document.data()}');

                  //           Map<String, dynamic> expense =
                  //               document.data() as Map<String, dynamic>;
                  //           print(expense['category']);
                  //           print(expense['value']);
                  //           print(expense['date']);
                  //         }
                  //         print("Documents successfully retrieved");
                  //       } catch (e) {
                  //         print("Documents not retrieved");
                  //       }
                  //     }),
                  Text(
                    "Add a new Expense...",
                    style: TextStyle(fontSize: 20),
                  ),
                  _buildValue(),
                  SizedBox(height: 25),
                  _buildDescription(),
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerLeft, // Align to the left
                    child: DropdownMenuExample(),
                  ),
                  // _buildCategory(),
                  // _buildDate(),
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerLeft, // Align to the left
                    child: ElevatedButton(
                      child: Text(
                        '${date.month}/${date.day}/${date.year}',
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (newDate == null) return;
                        setState(() => date = newDate);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(50, 20, 50, 20)),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        String expDate =
                            '${date.month}/${date.day}/${date.year}';
                        String expValue = _value.toString();
                        String expCategory = _selectedDropdownValue.toString();
                        String expDescription = _description.toString();
                        String expID = "";
                        print("It works");
                        try {
                          await FirebaseFirestore.instance
                              .collection("Expenses")
                              .doc(_user!.uid)
                              .collection("userExpenses")
                              .add({
                            'value': expValue,
                            'category': expCategory,
                            'date': expDate,
                            'description': expDescription,
                          }).then((value) => expID = value.id);

                          //Add expense locally to userExpenseByCategory
                          if (expCategory == "Shopping") {
                            userExpenseByCategory[1] =
                                (double.parse(userExpenseByCategory[1]) +
                                        double.parse(expValue))
                                    .toString();
                          } else if (expCategory == "Groceries") {
                            userExpenseByCategory[3] =
                                (double.parse(userExpenseByCategory[3]) +
                                        double.parse(expValue))
                                    .toString();
                          } else if (expCategory == "Cash Out") {
                            userExpenseByCategory[5] =
                                (double.parse(userExpenseByCategory[5]) +
                                        double.parse(expValue))
                                    .toString();
                          } else if (expCategory == "Travel") {
                            userExpenseByCategory[7] =
                                (double.parse(userExpenseByCategory[7]) +
                                        double.parse(expValue))
                                    .toString();
                          } else if (expCategory == "Entertainment") {
                            userExpenseByCategory[9] =
                                (double.parse(userExpenseByCategory[9]) +
                                        double.parse(expValue))
                                    .toString();
                          } else if (expCategory == "Bills") {
                            userExpenseByCategory[11] =
                                (double.parse(userExpenseByCategory[11]) +
                                        double.parse(expValue))
                                    .toString();
                          } else if (expCategory == "Other") {
                            userExpenseByCategory[13] =
                                (double.parse(userExpenseByCategory[13]) +
                                        double.parse(expValue))
                                    .toString();
                            print(userExpenseByCategory[13]);
                          }
                          print("expense successfully added");

                          expenseList.add({
                            "docID": expID,
                            "category": expCategory,
                            "value": expValue,
                            "date": expDate,
                            "description": expDescription,
                          });
                          widget.updateState(true);
                          print("SET STATE METHOD");
                          print(expenseList);
                          Navigator.pop(context);
                          _selectedDropdownValue = "Other";
                        } catch (e) {
                          print("Expense not added");
                        }
                      }
                      _selectedDropdownValue = "Other";
                    },
                    child: Text("Submit",
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  )
                ],
              ),
            )));
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          _selectedDropdownValue = value;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
