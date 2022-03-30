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
  const faceDetectedScreen({
    Key? key,
    required this.studentName,
    // required this.profilePhoto,
    required this.classes,
  }) : super(key: key);

  final String studentName;
  // final Image profilePhoto;
  final classes; // String array of class names

  @override
  _faceDetectedScreen createState() => new _faceDetectedScreen();
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

class _faceDetectedScreen extends State<faceDetectedScreen> {

  @override
  void initState() {

    loadAll();

    super.initState();
  }

  List _items = [];
  List profilePhoto = ["https://image.shutterstock.com/image-illustration/not-working-red-rubber-stamp-260nw-576995737.jpg"];

  void loadAll() {
    _items = [];
    print("items: ");
    print(_items);

    FirebaseFirestore.instance.collection("students").get().then((value) {
      value.docs.forEach((element) {
        print("ADDING ITEMS");
        print(element.data()["id"]);
        _items.add(element.data());
      });

      setState(() {
      });

      print(widget.studentName == "999111");

      for (var item in _items) {
        print(item);
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
      body: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text(widget.studentName),
              Image.network(
                  profilePhoto[profilePhoto.length-1]
              ),
              Text("Is this you?"),
              Center(
                child: Row(
                  children: [
                    ActionButton(
                        label: "Yes",
                        callback: (context) {
                        print("CONFIRMED, THIS IS STUDENT");
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Awesome, thanks!'),
                            content: const Text(''),
                            // TODO: MARK STUDENT PRESENT WHEN CLICK ON THIS BUTTON
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FaceDetectorView())),
                                child: const Text('Blah blah'),
                              ),
                            ],
                          ),
                        );


                        }
                    ),
                    ActionButton(
                        label: "No",
                        callback: (context) {
                          print("THIS IS not STUDENT");
                        }
                    )
                  ],
                ),
              )
            ],
          )
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