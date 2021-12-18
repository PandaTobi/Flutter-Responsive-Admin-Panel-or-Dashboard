import 'package:admin/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';

class AdminClassesScreen extends StatefulWidget {
  @override
  _AdminClassesState createState() => new _AdminClassesState();
}

class AppAction {
  final Color color;
  final String label;
  final Color labelColor;
  final IconData iconData;
  final Color iconColor;
  final void Function(BuildContext) callback;

  AppAction({
    this.color = Colors.blueGrey,
    this.label = "",
    this.labelColor = Colors.white,
    this.iconData = Icons.ac_unit,
    this.iconColor = Colors.white,
    required this.callback,
  });
}

class ActionButton extends StatelessWidget {
  final AppAction action;

  const ActionButton({
    Key key = const Key("any_key"),
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => action.callback.call(context),
      style: OutlinedButton.styleFrom(
        backgroundColor: action.color,
        padding: const EdgeInsets.all(16.0),
      ),
      label: Text(action.label, style: TextStyle(color: action.labelColor)),
      icon: Icon(action.iconData, color: action.iconColor),
    );
  }
}

final List<AppAction> actions = [
  AppAction(
    label: 'Class1',
    iconData: Icons.class_,
    callback: (context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => StudentScreen()));
    },
  ),
  AppAction(
    label: 'Class2',
    iconData: Icons.class_,
    callback: (context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => StudentScreen()));
    },
  ),
  AppAction(
    label: 'Class3',
    iconData: Icons.class_,
    callback: (context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => StudentScreen()));
    },
  ),
  AppAction(
    color: Colors.green.shade200,
    label: 'Class4',
    labelColor: Colors.black,
    iconData: Icons.class_,
    iconColor: Colors.green,
    callback: (context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => StudentScreen()));
    },
  ),
];

class _AdminClassesState extends State<AdminClassesScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      pageTitle: 'Classes Page',
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(30.0),
        child: ListView(
              padding: const EdgeInsets.all(8),
              children: actions.map((action) => ActionButton(action: action)).toList(),


        ),
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
      pageTitle: 'News Page',
      child: Center(
        child: Text('NEWS', style: TextStyle(color: Colors.green)),
      ),
    );
  }
}