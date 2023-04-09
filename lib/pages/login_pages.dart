import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPages extends StatelessWidget {
  const LoginPages({super.key});

  //!do login
  doLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'toha@demo.com', password: '12345678');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () => doLogin(), child: Text('Login')),
      ),
    );
  }
}
