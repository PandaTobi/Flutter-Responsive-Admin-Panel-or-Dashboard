import 'package:admin/screens/login/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'login_form.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LoginScreen extends StatelessWidget {
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
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/icon/icon.png'),
                            fit: BoxFit.contain,
                            alignment: Alignment.center)),
                  ),
                  SizedBox(height: 30),
                  LoginForm(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Don\'t have an account?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen())), // TODO: Change here
                          child: Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).accentColor)),
                        ),
                      ]),
                ],
              ),
            )));
  }
}