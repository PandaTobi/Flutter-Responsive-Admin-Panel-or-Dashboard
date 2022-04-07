import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/school_home/add_class.dart';
import 'package:admin/screens/school_home/edit_class_page.dart';
import 'package:admin/screens/school_home/student_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';

class AdminClassesScreen extends StatefulWidget {
  @override
  _AdminClassesState createState() => new _AdminClassesState();
}



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

class _AdminClassesState extends State<AdminClassesScreen> {

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  List _items = [];

  void loadAll() {
    _items = [];
    FirebaseFirestore.instance.collection("classes").get().then((value) {
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
               margin: EdgeInsets.fromLTRB(0, 60, 0, 10),
              child: Text(
                  "Class Management",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w100,
                      fontFamily: 'RaleWay',
                      color: Colors.white
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(30.0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        // height: 50,
                        // width: 700,
                        // child: Center(child: ActionButton(
                        //   label: _items[index]["name"],
                        //   iconData: Icons.class_,
                        //   callback: (context) {
                        //     Navigator.of(context)
                        //         .push(MaterialPageRoute(builder: (_) => EditClassPage(_items[index]["id"])));
                        //   },)
                      margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(3.0, -1.0),
                            colors: [
                              Color(0xFF8ea4c6),
                              Color(0xff557878),
                            ],
                          ),
                        ),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(width: 1.0, color: Colors.white24))),
                              child: Icon(Icons.class__outlined, color: Colors.white),
                            ),
                            title: Text(
                              _items[index]["name"],
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                            subtitle: Row(
                              children: <Widget>[
                                Icon(Icons.linear_scale, color: Colors.black),
                                Text("Time: 6:30 PM", style: TextStyle(color: Colors.white))
                              ],
                            ),
                            trailing:
                            Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0))
                        );
                  })
          ),
          ]
        ),
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


class ScreenLayout extends StatelessWidget {
  final String pageTitle;
  final Widget child;

  const ScreenLayout({Key key = const Key("any_key"), required this.pageTitle, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: child,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

        },
      ),
    );
  }
}

class StudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      pageTitle: 'Class Page',
      child: Center(
        child: Text('Put listview of students in here', style: TextStyle(color: Colors.green)),
      ),
    );
  }
}