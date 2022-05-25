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
    String s = widget.CLASS_IDS.join(" ");
    return Scaffold(
      body: Center(
          child: Text(
            'You have pressed the button $s times.',
            style: TextStyle(color: Colors.white),
          )
      ),

    );
  }


}
