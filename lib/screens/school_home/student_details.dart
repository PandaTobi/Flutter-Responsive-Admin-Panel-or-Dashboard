import 'package:admin/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';

class StudentDetails extends StatelessWidget {
  // Requiring the list of todos.
  const StudentDetails({Key? key, required this.name, required this.id}) : super(key: key);

  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      //passing in the ListView.builder
      body: Column(
        children: [
          Text(
            name,
            style: TextStyle(color: Colors.white),
        ),
          Text(
            id,
            style: TextStyle(color: Colors.white),
          )
        ]
      )
    );
  }
}