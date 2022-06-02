import 'package:admin/screens/school_home/admin_home_screen.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../camera.dart';
import 'camera_view.dart';
import 'painters/face_detector_painter.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;
import 'image_display_view.dart' as idv;

class DisplayNameView extends StatefulWidget {
  // TODO: UPON INIT, CREATE/LOAD A LIST OF STUDENTS FOR DESIGNATED CLASS
  const DisplayNameView({Key? key, required this.CLASS_IDS}) : super(key: key);

  final List CLASS_IDS;

  @override
  _DisplayNameViewState createState() => _DisplayNameViewState();
}

class _DisplayNameViewState extends State<DisplayNameView> {

  @override
  Widget build(BuildContext context) {
    String s = widget.CLASS_IDS.join(", ");
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 60, 0, 10),
                child: Center(
                  child: Text(
                      "List of students who are absent:",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'RaleWay',
                          color: Colors.white
                      )
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(30.0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: widget.CLASS_IDS.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(

                            margin: EdgeInsets.all(5),
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
                            child: ListTile(

                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

                                leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(width: 1.0, color: Colors.white24))),
                                  child: Icon(Icons.class__outlined, color: Colors.white),
                                ),
                                title: Text(
                                  widget.CLASS_IDS[index],
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),


                                trailing:
                                Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0))
                        );
                      })
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminHomeScreen()));

          // TODO: CONFIRMATION SCREEN
        },
      ),
    );
  }


}
