import 'package:admin/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';

class SchoolHomeScreen extends StatefulWidget {
  @override
  _SchoolHomeState createState() => new _SchoolHomeState();
}

class _SchoolHomeState extends State<SchoolHomeScreen> {

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
                  "School Home Screen",
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