import 'package:admin/screens/school_home/student_list.dart';
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
    loadAll();
  }

  List _items = [];

  List id_list = [];

  Future<void> loadAll() async {
    _items = [];
    FirebaseFirestore.instance.collection("students").get().then((value) {
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

    id_list = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.studentId)
        .get()
        .then((value) {
      return value.data()!['student_list']; // Access your after your get the data
    }) as List;

    print("######################## ID LIST HERE #############################");
    print(id_list);
  }

  void loadClass(stuId) {
      // _items = [];
    print("this si executing");

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

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StudentList(class_id: widget.studentId))
                      );
                    },
                    child: Text("Add Student")
                ),
              ),
              Flexible(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (id_list.contains(_items[index]["id"])){
                        return Container(
                            height: 50,
                            width: 700,
                            child: Center(child: ActionButton(
                              label: _items[index]["name"],
                              iconData: Icons.class_,
                              callback: (context) {
                                // do something here

                              },)
                            ));
                      } else {
                        return Container();
                      }
                    }),
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