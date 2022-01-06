import 'package:admin/screens/login/login_screen.dart';
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

final List<String> names = ["Class1", "Class2", "Class3", "Class4", ];



// {}

class _AdminClassesState extends State<AdminClassesScreen> {

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  List _items = [];

  Future<void> ReadJsonData() async {
    //read json file
    final jsondata = await rootBundle.loadString('assets/data.json');
    //decode json data as list
    final data = await json.decode(jsondata);
    setState(() {
      _items = data["classes"];
    });
  }

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
    return ScreenLayout(
      pageTitle: 'Classes Page',
      child: Container(
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