import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'camera.dart';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  var url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: idController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Id',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: nameController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed:  () async {
                    WidgetsFlutterBinding.ensureInitialized();

                    // Obtain a list of the available cameras on the device.
                    final cameras = await availableCameras();
                    final firstCamera = cameras.first;
                    url = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera, useLocalPath: false,))
                    );

                    print(url);
                  },
                  child: Text(
                    "Take a photo"
                  )
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      if (idController.text == "" || nameController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Please fill in all the information"),
                        ));
                      } else {
                        // how to save the data to FireStore
                        var id = idController.text.toString();
                        FirebaseFirestore.instance.collection("students").doc(id).get().then((value) {
                          if (value.exists) {
                            print("Document exist.");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Student ID already exists. Please use the correct ID."),
                            ));
                          } else {

                            var classRecord = {
                              "id" : idController.text,
                              "name" : nameController.text,
                              "profile_url": url,
                            };



                            FirebaseFirestore.instance.collection("students").doc(id).set(classRecord).then((value) {
                              print("Student added successfully.");
                              Navigator.pop(context);
                            }).catchError((e) {
                              print("Failed to add class.");
                              print(e);


                            });
                          }
                        }).catchError((e) {
                          print("Failed to add class");
                          print(e);


                        });
                      }
                    },
                    child: Text("Create")
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}