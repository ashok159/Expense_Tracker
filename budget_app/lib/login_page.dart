import 'package:budget_app/expButton.dart';
import 'package:budget_app/get_cloud_data.dart';
import 'package:budget_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_app/summary_view.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();`
//     final passwordController = TextEditingController();
//     String errorMessage = '';

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Center(
//           child: Text('Login'),
//         ),
//       ),
//       backgroundColor: Colors.indigo.shade400,
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 500,
//                 child: TextField(
//                   controller: emailController,
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                       labelText: 'Enter your email',
//                       labelStyle: TextStyle(color: Colors.white),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       )),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 width: 500,
//                 child: TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                       labelText: 'Enter your password',
//                       labelStyle: TextStyle(color: Colors.white),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       )),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   String email = emailController.text;
//                   String password = passwordController.text;

//                   try {
//                     await FirebaseAuth.instance.signInWithEmailAndPassword(
//                       email: email,
//                       password: password,
//                     );
//                     getExpenseList();
//                     print('User successfully signed in');
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MyApp()));
//                   } on FirebaseAuthException {
//                     errorMessage =
//                         'Error: Invalid credentials, please try again.';
//                     print('Error signing in');
//                   } catch (e) {
//                     print('An unexpected error occurred.');
//                   }

//                   if (errorMessage.isNotEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(errorMessage),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }

//                   errorMessage = '';
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.teal),
//                 ),
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String errorMessage = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(
          child: Text('Login', style: TextStyle(fontSize: 24)),
        ),
      ),
      backgroundColor: Colors.indigo.shade400,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  String password = passwordController.text;

                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    getExpenseList();
                    print('User successfully signed in');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  } on FirebaseAuthException {
                    errorMessage =
                        'Error: Invalid credentials, please try again.';
                    print('Error signing in');
                  } catch (e) {
                    print('An unexpected error occurred.');
                  }

                  if (errorMessage.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  errorMessage = '';
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
