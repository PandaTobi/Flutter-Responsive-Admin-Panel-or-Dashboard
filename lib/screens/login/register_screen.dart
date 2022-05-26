import 'package:admin/screens/login/register_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'login_form.dart';
import 'login_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain,
                            alignment: Alignment.center)),
                  ),
                  SizedBox(height: 30),
                  RegisterForm(),
                ],
              ),
            )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: () {

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginScreen()));

          // TODO: CONFIRMATION SCREEN
        },
      ),);
  }
}