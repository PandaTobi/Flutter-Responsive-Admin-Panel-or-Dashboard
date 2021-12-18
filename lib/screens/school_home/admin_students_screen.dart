import 'package:admin/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';

class AdminStudentScreen extends StatefulWidget {
  @override
  AdminStudentsState createState() => new AdminStudentsState();
}

class AdminStudentsState extends State<AdminStudentScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "This is the admin students screen\n As the classes page redirects you to this page, accept input from the entry that takes you to this screen",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}