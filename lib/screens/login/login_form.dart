import 'package:admin/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'input_text_field.dart';


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    String email = "email@gmail.com";
    String password = "Password";

    TextEditingController emailController = new TextEditingController(text: "email@gmail.com");
    TextEditingController passwordController = new TextEditingController(text: "Password");


    const textInputDecoration = InputDecoration(
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple, width: 4.0),
      ),
    );

    return Form(
        key: _formKey,
        //autovalidate: true,

        child: Container(
            width: MediaQuery.of(context).size.width * 0.90,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(

                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: TextFormField(

                    decoration: textInputDecoration.copyWith(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        fillColor: Colors.black
                    ),
                    style: TextStyle(color: Colors.white),

                    controller: emailController,
                  ),
                ),

                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      fillColor: Colors.black
                  ),
                  style: TextStyle(color: Colors.white),
                  controller: passwordController,
                ),
                Container(
                    margin: EdgeInsets.all(20),
                    child: FlatButton.icon(
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(12),
                        color: Theme.of(context).accentColor,
                        onPressed: () async {
                          print(emailController.text);
                          try {

                            print(passwordController.text);
                            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text
                            );

                            if (_formKey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            }

                            print("user successfully created");
                          } on FirebaseAuthException catch (e) {
                            print("wrong");
                          } catch (e) {
                            print(e);
                          }


                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )));
  }
}

/*
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple, width: 4.0),
  ),
);

* TextFormField(
                decoration: textInputDecoration.copyWith(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                ),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
              ),

* */