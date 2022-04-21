import 'package:admin/screens/school_home/student_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit_student_page.dart';

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
      setState(() {});
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
      return value
          .data()!['student_list']; // Access your after your get the data
    }) as List;

    print(
        "######################## ID LIST HERE #############################");
    print(id_list);
  }

  void loadClass(stuId) {
    // _items = [];
    print("this si executing");

    FirebaseFirestore.instance
        .collection("classes")
        .doc(stuId)
        .get()
        .then((value) {
      print(value.data());
      idController.text = value.data()!['id'];
      nameController.text = value.data()!['name'];
      descriptionController.text = value.data()!['description'];
      setState(() {});
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
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Text("Edit your class",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w100,
                        fontFamily: 'RaleWay',
                        color: Colors.white)),
              ),
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
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF8ea4c6),
                    ),
                    onPressed: () {
                      // update the class in Firebase Firestore
                      var classRecord = {
                        "id": idController.text,
                        "name": nameController.text,
                        "description": descriptionController.text
                      };

                      FirebaseFirestore.instance
                          .collection("classes")
                          .doc(widget.studentId)
                          .set(classRecord)
                          .then((value) {
                        print("Class updated successfully.");
                        Navigator.pop(context);
                      }).catchError((e) {
                        print("Failed to update the class.");
                        print(e);
                      });
                    },
                    child: Text(
                        "Update",
                        style: TextStyle(color: Colors.black87)
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF8ea4c6),
                    ),
                    onPressed: () {
                      // search in Firestore
                      // TODO 1: Add a new search screen to show all students by default
                      // TODO 2: Implement a typing-based filtering for the listview

                      FirebaseFirestore.instance
                          .collection("students")
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          print(element.data());
                        });
                      }).catchError((e) {
                        print("Failed to update the class.");
                        print(e);
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StudentList(class_id: widget.studentId)));
                    },
                    child: Text("Add Student", style: TextStyle(color: Colors.black87))),
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: Text("Students",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w100,
                              fontFamily: 'RaleWay',
                              color: Colors.white)),
                    ),
                    Container(
                        margin: EdgeInsets.all(3),
                        padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _items.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (id_list.contains(_items[index]["id"])) {
                                return Container(
                                  height: 400,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      begin: FractionalOffset(0.0, 0.0),
                                      end: FractionalOffset(3.0, -1.0),
                                      colors: [
                                        Color(0xFF8ea4c6),
                                        Color(0xff557878),
                                      ],
                                    ),
                                  ),
                                  margin: EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Color(0xFF8ea4c6),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: InkWell(
                                        child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Image.network(
                                              _items[index]["profile_url"],
                                              fit: BoxFit.contain),
                                        ),
                                        ListTile(
                                          title: Text(_items[index]["name"]),
                                          subtitle: Text('Lorem ipsum'),
                                        ),
                                      ],
                                    )),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            })),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF8ea4c6),
        child: IconTheme(
            data: new IconThemeData(
                color: Colors.black87),
            child: Icon(Icons.home)
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
// if (id_list.contains(_items[index]["id"])){
