import 'dart:io';
import 'dart:typed_data';

import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/school_home/camera.dart';
import 'package:admin/screens/school_home/face_detector/detected_information.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as rek;

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../main/main_screen.dart';
import 'face_detector/face_detectorview.dart';

var credentials = rek.AwsClientCredentials(secretKey: '4tHP09vwWbnvlHtYmJzereOm3E/RkUgFpMLKfv6/', accessKey: 'AKIAZADLXOUB3433QRUY');

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeState createState() => new _AdminHomeState();
}

class _AdminHomeState extends State<AdminHomeScreen> {

  var service = rek.Rekognition(region: 'us-west-1', credentials: credentials);


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
              ),
              ElevatedButton(
                  onPressed: () {
                    // how to create a collection
                    service.createCollection(collectionId: "andyproject").then((value) {
                      print("Successfully created a collection!");
                      print(value);
                    }).catchError((e) {
                      print("Failed to create a collection!");
                    });
                  },
                  child: Text("Create a Collection")
              ),
              ElevatedButton(
                  onPressed: () async {
                    // how to create a collection
                    ByteData bytes = await rootBundle.load('assets/images/andytest.jpg');
                    // File file = await getImageFileFromAssets('assets/images/yutest.jpeg');
                    // Uint8List bytes = file.readAsBytesSync();
                    var image = rek.Image(bytes: bytes.buffer.asUint8List());
                    service.indexFaces(collectionId: "andyproject", image: image, externalImageId: "user-andy")
                        .then((value) {
                          print("Successfully indexed the image.");
                          print(value.faceRecords);
                        }).catchError((e) {
                          print("Failed to index the image.");
                          print(e);
                        });
                  },
                  child: Text("Index Face")
              ),
              ElevatedButton(
                  onPressed: () async {
                    // Obtain a list of the available cameras on the device.
                    final cameras = await availableCameras();

                    // Get a specific camera from the list of available cameras.
                    final firstCamera = cameras.first;

                    var path = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera, useLocalPath: true,))
                    );

                    print(path);

                    // how to create a collection
                    // ByteData bytes = await rootBundle.load('assets/images/yutest.jpeg');
                    File file = File(path);
                    Uint8List bytes = file.readAsBytesSync();
                    var image = rek.Image(bytes: bytes);
                    service.searchFacesByImage(collectionId: "andyproject", image: image)
                        .then((value) {
                      print("Successfully found the image.");
                      print(value.faceMatches);
                    }).catchError((e) {
                      print("Failed to find the image.");
                      print(e);
                    });
                  },
                  child: Text("Search Face")
              ),
              ElevatedButton(
                  onPressed: () async {
                    ByteData bytes = await rootBundle.load('assets/images/andytest.jpg');
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => faceDetectedScreen(
                            studentName: "Andy",
                            // profilePhoto: Image.memory(bytes.buffer.asUint8List()),
                            classes: ["Math", "English"])
                        )
                    );
                  },
                  child: Text(
                      "ON FACE DETECTED SCREEN"
                  )
              ),
              CustomCard(
                'Face Detector',
                FaceDetectorView(),
                featureCompleted: true,
              ),
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
              MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera, useLocalPath: false,))
          );
        },
      ),
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


