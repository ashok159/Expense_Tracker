import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class SignupPage extends StatelessWidget {
//   const SignupPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();
//     final usernameController = TextEditingController();
//     final passwordController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: Center(
//           child: Text('Sign Up'),
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
//                   controller: usernameController,
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                       labelText: 'Enter your username',
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
//                   String username = usernameController.text;
//                   String password = passwordController.text;

//                   try {
//                     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//                       email: email,
//                       password: password,
//                     );

//                     String userID = userCredential.user!.uid;

//                     await FirebaseFirestore.instance.collection("Users").doc(userID).set({
//                       'email': email,
//                       'username': username,
//                       'password': password,
//                     });

//                     print('User registered and their data added to Firestore');
//                   } catch (e) {
//                     print('Error registering and adding user to Firestore');
//                   }
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.teal),
//                 ),
//                 child: const Text('Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(
          child: Text('Sign Up', style: TextStyle(fontSize: 24)),
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
                  controller: usernameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
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
                  String username = usernameController.text;
                  String password = passwordController.text;

                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    String userID = userCredential.user!.uid;

                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(userID)
                        .set({
                      'email': email,
                      'username': username,
                      'password': password,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User registered successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    print('User registered and their data added to Firestore');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Error registering user. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    print('Error registering and adding user to Firestore');
                  }
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
                  'Sign Up',
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
