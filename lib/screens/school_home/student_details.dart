import 'package:admin/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';


class StudentDetails extends StatefulWidget {
  // Requiring the list of todos.
  const StudentDetails({Key? key, required this.name, required this.id}) : super(key: key);

  final String name;
  final String id;

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
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
            widget.name,
            style: TextStyle(color: Colors.white),
        ),
          Text(
            widget.id,
            style: TextStyle(color: Colors.white),
          )
        ]
      )
    );
  }
}