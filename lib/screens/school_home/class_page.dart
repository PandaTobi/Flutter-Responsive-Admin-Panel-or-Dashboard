import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/school_home/add_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';

class ActionButton extends StatelessWidget {
  Color? color;
  String? label;
  Color? labelColor;
  IconData? iconData;
  Color? iconColor;
  late void Function(BuildContext) callback;

  ActionButton({
    this.color = Colors.blueGrey,
    this.label,
    this.labelColor = Colors.white,
    this.iconData = Icons.ac_unit,
    this.iconColor = Colors.white,
    required this.callback,
  });



  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => callback.call(context),
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(16.0),
      ),
      label: Text(label!, style: TextStyle(color: labelColor)),
      icon: Icon(iconData, color: iconColor),
    );
  }
}

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreen createState() => new _StudentScreen();
}


class _StudentScreen extends State<StudentScreen> {
  @override
  void initState() {
    super.initState();
    loadAll();
  }

  List _items = [];

  void loadAll() {
    _items = [];
    FirebaseFirestore.instance.collection("students").get().then((value) {
      // print(value);
      value.docs.forEach((element) {
        // var classRecord = element.data();
        print(element.data());
        _items.add(element.data());
        // see what the format of the element.data()
        // and then figure out how to add it to the list

        // tempAllStatusList.add(statusRecord);
      });
      setState(() {

      });
    }).catchError((e) {
      print("Failed to get the list");
      print(e);
      throw e;
    });
  }

  void addStudent (name) {
    // FirebaseFirestore.instance.collection('messages').push().set(name.toJson());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Class Management")),
      body: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(30.0),
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: 50,
                    width: 700,
                    child: Center(child: ActionButton(
                      label: _items[index]["name"],
                      iconData: Icons.class_,
                      callback: (context) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => StudentScreen()));
                      },)
                    ));
              })
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddClassPage())
          ).then((value) {
            loadAll();
          });
        },
      ),
    );
  }
}