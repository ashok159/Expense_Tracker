import 'package:budget_app/get_cloud_data.dart';
import 'package:budget_app/summary_view.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_app/main.dart';
import 'charts_page.dart';
import 'bar_graph.dart';

//void main() => runApp(const MyApp());

User? _user = FirebaseAuth.instance.currentUser;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getExpenseByCategory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while initializing
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle initialization error
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            ),
          );
        } else {
          // Initialization is complete, return homepage
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _update = false;
  final GlobalKey<Chart2State> chartsPageKey = GlobalKey<Chart2State>();

  void _updateSummaryView(bool newState) {
    setState(() {
      _update = newState;
    });
  }

  void updateChartsPageState() {
    if (chartsPageKey.currentState != null) {
      chartsPageKey.currentState!.updateState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Budget App'),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  dumpUserExpenseByCategory();
                  await FirebaseAuth.instance.signOut();
                  clearExpenseList();
                  print("Signed out.");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExpenseTracker()));
                  print(expenseList);
                },
                child: Text("LogOut"))
          ],
        ),
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Center(
                    child: FormScreen(
                  updateState: _updateSummaryView,
                ));
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10), // Add some margin
                    padding: EdgeInsets.all(20), // Add some padding
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ChartsPage(
                        expense: userExpenseByCategory,
                        key: chartsPageKey,
                        updateParentState: updateChartsPageState,
                      ),
                    ),
                  ),
                ),

                // Expanded(
                //   child: Container(
                //     margin: EdgeInsets.all(10), // Add some margin
                //     padding: EdgeInsets.all(20), // Add some padding
                //     decoration: BoxDecoration(
                //       color: Colors.white, // Background color
                //       borderRadius: BorderRadius.circular(10), // Rounded corners
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.5), // Shadow color
                //           spreadRadius: 5,
                //           blurRadius: 7,
                //           offset: Offset(0, 3), // Offset of the shadow
                //         ),
                //       ],
                //     ),
                //     child: SizedBox(
                //       width: double.maxFinite,
                //       height: MediaQuery.of(context).size.height * 0.35,
                //       child: BarGraph(),
                //     ),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10), // Add some margin
                    padding: EdgeInsets.all(20), // Add some padding
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height *
                      //     0.5, // Set a fixed height
                      width: double.maxFinite,
                      child: SummaryView(
                        chartsPageKey: chartsPageKey,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        )));
  }
}
