import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/school_home/add_class.dart';
import 'package:admin/screens/school_home/edit_class_page.dart';
import 'package:admin/screens/school_home/face_detector/face_detectorview.dart';
import 'package:admin/screens/school_home/student_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

/*
#
REDIRECT TO THIS PAGE WHEN DETECTED A FACE
 */

class faceDetectedScreen extends StatefulWidget {
  const faceDetectedScreen(
      {Key? key, required this.studentName, required this.ids})
      : super(key: key);

  final String
      studentName; // TODO: MARKS ATTENDANCE BASED ON NAME RN, NEED TO CHANGE TO ID-BASED ATTENDANCE
  final List ids;

  @override
  _faceDetectedScreen createState() => new _faceDetectedScreen();
}

class ActionButton extends StatelessWidget {
  Color color;
  String? label;
  Color? labelColor;
  IconData? iconData;
  Color? iconColor;
  late void Function(BuildContext) callback;

  ActionButton({
    this.color = const Color(0xFF8ea4c6),
    this.label,
    this.labelColor = Colors.black87,
    this.iconData,
    this.iconColor = Colors.black87,
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

class _faceDetectedScreen extends State<faceDetectedScreen> {
  @override
  void initState() {
    loadAll();

    super.initState();
  }

  List _items = [];
  List profilePhoto = [
    "https://image.shutterstock.com/image-illustration/not-working-red-rubber-stamp-260nw-576995737.jpg"
  ];

  void loadAll() {
    _items = [];

    FirebaseFirestore.instance.collection("students").get().then((value) {
      value.docs.forEach((element) {
        print("ADDING ITEMS");
        print(element.data()["id"]);
        _items.add(element.data());
      });

      setState(() {});

      for (var item in _items) {
        if (item["id"] == widget.studentName) {
          print("this works!");
          profilePhoto.add(item["profile_url"]);
        } else {
          print("this does not!");
        }
      }
    }).catchError((e) {
      print("Failed to get the list");
      print(e);
      throw e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Class Management")),
      body: Center(
          child: Container(
        height: 500,
        width: 300,
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
              child: Column(
            children: [
              Text(
                "ID: " + widget.studentName,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30,
                    fontFamily: 'RaleWay',
                    fontWeight: FontWeight.bold),
              ),
              Image.network(profilePhoto[profilePhoto.length - 1]),
              Text(
                "Is this you?",
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                    child: ActionButton(
                        iconData: Icons.check,
                        label: "Yes",
                        callback: (context) {
                          print("CONFIRMED, THIS IS STUDENT");
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                'Awesome, thanks!',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(''),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    widget.ids.remove(widget.studentName);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FaceDetectorView(
                                                    CLASS_IDS: widget.ids)));
                                  },
                                  child: const Text(
                                    'Return to Face Detection',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  ActionButton(
                      iconData: Icons.close,
                      label: "No",
                      callback: (context) {
                        print("THIS IS not STUDENT");
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                              'Sorry, who are you?',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(''),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  widget.ids.remove(widget.studentName);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FaceDetectorView(
                                                  CLASS_IDS: widget.ids)));
                                },
                                child: const Text(
                                  'Return to Face Detection',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ],
          )),
        ),
      )),
    );
  }
}

class ScreenLayout extends StatelessWidget {
  final String pageTitle;
  final Widget child;

  const ScreenLayout(
      {Key key = const Key("any_key"),
      required this.pageTitle,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: child,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
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
        child: Text('Put listview of students in here',
            style: TextStyle(color: Colors.green)),
      ),
    );
  }
}
