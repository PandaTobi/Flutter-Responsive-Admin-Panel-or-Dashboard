import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditClassPage extends StatefulWidget {

  String studentId;

  EditClassPage(this.studentId);

  @override
  _EditClassPageState createState() => _EditClassPageState();
}

class _EditClassPageState extends State<EditClassPage> {

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadClass(widget.studentId);
  }

  void loadClass(stuId) {
      // _items = [];
      FirebaseFirestore.instance.collection("classes").doc(stuId).get().then((value) {
        print(value.data());
        idController.text = value.data()!['id'];
        nameController.text = value.data()!['name'];
        descriptionController.text = value.data()!['description'];
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
                enabled: false,
                style: TextStyle(color: Colors.white),
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
                style: TextStyle(color: Colors.white),
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
                style: TextStyle(color: Colors.white),
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
                      // update the class in Firebase Firestore
                      var classRecord = {
                        "id" : idController.text,
                        "name" : nameController.text,
                        "description" : descriptionController.text
                      };

                      FirebaseFirestore.instance.collection("classes").doc(widget.studentId).set(classRecord).then((value) {
                        print("Class updated successfully.");
                        Navigator.pop(context);
                      }).catchError((e) {
                        print("Failed to update the class.");
                        print(e);
                      });
                    },
                    child: Text("Update")
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
                      // search in Firestore
                      // TODO 1: Add a new search screen to show all students by default
                      // TODO 2: Implement a typing-based filtering for the listview

                      FirebaseFirestore.instance.collection("students").get().then((value) {

                        value.docs.forEach((element) {
                          print(element.data());
                        });
                      }).catchError((e) {
                        print("Failed to update the class.");
                        print(e);
                      });
                    },
                    child: Text("Add Student")
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