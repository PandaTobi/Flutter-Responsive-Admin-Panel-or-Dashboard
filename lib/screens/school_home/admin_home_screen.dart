import 'dart:async';
import 'dart:io';

import 'package:admin/screens/school_home/admin_classes_screen.dart';
import 'package:admin/screens/school_home/admin_students_screen.dart';
import 'package:admin/screens/school_home/camera.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as rek;
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_screen.dart';
import 'face_detector/class_list_screen.dart';
import 'face_detector/face_detectorview.dart';

var credentials = rek.AwsClientCredentials(
    secretKey: '4tHP09vwWbnvlHtYmJzereOm3E/RkUgFpMLKfv6/',
    accessKey: 'AKIAZADLXOUB3433QRUY');

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeState createState() => new _AdminHomeState();
}

class _AdminHomeState extends State<AdminHomeScreen> {
  var service = rek.Rekognition(region: 'us-west-1', credentials: credentials);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  ///sign out
  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Card makeDashboardItem(String title, Icon icon, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(3.0, -1.0),
                  colors: [
                    Color(0xFF8ea4c6),
                    Color(0xff698484),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 3,
                    offset: Offset(2, 2),
                  )
                ],
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(3.0, -1.0),
                  colors: [
                    Colors.black45,
                    Colors.blueGrey,
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 3,
                    offset: Offset(2, 2),
                  )
                ],
              ),
        child: InkWell(
          onTap: () {
            /* TODO: REDIRECT TO PAGE OF CLASSES WHICH, WHEN ONE IS CLICKED ON, WILL SUPPLY
                INFORMATION OF IDS OF STUDENTS IN THAT CLASS TO THE FACEDETECTORVIEW
             */
            if (index == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new ClassListScreen()));
            }
            if (index == 1) {
              //2.item
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new AdminStudentScreen()));
            }
            if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new AdminClassesScreen()));
            }
            if (index == 3) {
              signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
            if (index == 4) {
              //5.item
            }
            if (index == 5) {
              //6.item
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(child: icon),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String min = now.minute.toString();
    new Timer.periodic(
      Duration(minutes: 1),
      (Timer t) {
        if (mounted) {
          setState(() {
            now = DateTime.now();
            min = now.minute.toString();
          });
        } else {
          t.cancel;
        }
      },
    );

    if (min.length == 1) {
      min = "0" + now.minute.toString();
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Dashboard",
                style: TextStyle(fontSize: 30, color: Colors.white)),
            Text(now.hour.toString() + ":" + min,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                    fontFamily: 'RaleWay',
                    color: Colors.white)),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(2),
                children: [
                  makeDashboardItem("Face Detector", Icon(Icons.camera), 0),
                  makeDashboardItem("Students", Icon(Icons.person), 1),
                  makeDashboardItem("Classes", Icon(Icons.class__rounded), 2),
                  makeDashboardItem("Sign Out", Icon(Icons.chat_rounded), 3),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 140),
              child: Text("Next class: AP Math",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.camera_alt),
      //   onPressed: () async {
      //     WidgetsFlutterBinding.ensureInitialized();
      //
      //     // Obtain a list of the available cameras on the device.
      //     final cameras = await availableCameras();
      //
      //     // Get a specific camera from the list of available cameras.
      //     final firstCamera = cameras.first;
      //
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => TakePictureScreen(
      //                   camera: firstCamera,
      //                   useLocalPath: false,
      //                 )));
      //   },
      // ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;

  const CustomCard(this._label, this._viewPage,
      {this.featureCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          _label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (Platform.isIOS && !featureCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                    'This feature has not been implemented for iOS yet')));
          } else
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => _viewPage));
        },
      ),
    );
  }
}
