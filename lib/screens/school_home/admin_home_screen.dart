import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/school_home/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeState createState() => new _AdminHomeState();
}

class _AdminHomeState extends State<AdminHomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "This is the admin home screen",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          WidgetsFlutterBinding.ensureInitialized();

          // Obtain a list of the available cameras on the device.
          final cameras = await availableCameras();

          // Get a specific camera from the list of available cameras.
          final firstCamera = cameras.first;


          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera))
          );
        },
      ),
    );
  }
}