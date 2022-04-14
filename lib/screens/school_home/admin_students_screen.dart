import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/school_home/add_class.dart';
import 'package:admin/screens/school_home/edit_student_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';
import 'add_student.dart';

class AdminStudentScreen extends StatefulWidget {
  @override
  _AdminStudentScreen createState() => new _AdminStudentScreen();
}

class _AdminStudentScreen extends State<AdminStudentScreen> {
  @override
  void initState() {
    super.initState();
    loadAll();
  }

  List _items = [];

  void loadAll() {
    _items = [];
    FirebaseFirestore.instance.collection("students").get().then((value) {
      value.docs.forEach((element) {
        _items.add(element.data());
      });
      setState(() {});
    }).catchError((e) {
      print("Failed to get the list");
      print(e);
      throw e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text(
                  "Students",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w100,
                      fontFamily: 'RaleWay',
                      color: Colors.white
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.all(20.0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 400,
                      width: 200,
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
                      margin: EdgeInsets.all(8.0),
                      child: Card(
                        color: Color(0xFF8ea4c6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      EditStudentPage(_items[index]["id"])));
                            },
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Image.network(_items[index]["profile_url"],
                                      fit: BoxFit.contain),
                                ),
                                ListTile(
                                  title: Text(_items[index]["name"]),
                                  subtitle: Text('Lorem ipsum'),
                                ),
                              ],
                            )),
                      ),
                    );
                  })),]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddStudentPage()))
              .then((value) {
            loadAll();
          });
        },
      ),
    );
  }
}
