import 'package:budget_app/get_cloud_data.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_app/main.dart';
import 'package:budget_app/summary_view.dart';

void main() => runApp(AddExpenseButton());

class AddExpenseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainButton(),
    );
  }
}

class MainButton extends StatefulWidget {
  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool _update = false;

  void _updateSummaryView(bool newState) {
    setState(() {
      _update = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Budget App'),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  clearExpenseList();
                  print("Signed out.");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExpenseTracker()));
                  print('Login Pressed');
                },
                child: Text("LogOut"))
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                //SummaryView(),
                Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Center(
                                  child: FormScreen(
                                      updateState: _updateSummaryView));
                            },
                          );
                        },
                        child: Center(
                            child: Text('+',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25))),
                        style: ElevatedButton.styleFrom(
                            // padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100))),
                      ),
                    ))
              ],
            )
            // padding: EdgeInsets.all(25),
            // child: Align(
            //     alignment: Alignment.bottomRight,
            //     child: SizedBox(
            //       width: 70,
            //       height: 70,
            //       child: ElevatedButton(
            //         onPressed: () {
            //           showModalBottomSheet(
            //             context: context,
            //             builder: (context) {
            //               return Center(child: FormScreen());
            //             },
            //           );
            //         },
            //         child: Center(
            //             child: Text('+',
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(fontSize: 25))),
            //         style: ElevatedButton.styleFrom(
            //             // padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(100))),
            //       ),
            //     ))),
            ));
  }
}
