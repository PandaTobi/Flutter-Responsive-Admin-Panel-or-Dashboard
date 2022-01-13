import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddClassPage extends StatefulWidget {
  @override
  _AddClassPageState createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
              TextField(
                controller: descriptionController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              SizedBox(
                height: 10,
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
                        FirebaseFirestore.instance.collection("classes").doc(id).get().then((value) {
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
                              "description" : descriptionController.text
                            };

                            FirebaseFirestore.instance.collection("classes").doc(id).set(classRecord).then((value) {
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