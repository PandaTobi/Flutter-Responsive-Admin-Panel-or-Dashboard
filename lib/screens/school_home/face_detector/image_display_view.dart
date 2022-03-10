import 'package:flutter/material.dart';
import 'dart:io';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as rek;

var credentials = rek.AwsClientCredentials(secretKey: '4tHP09vwWbnvlHtYmJzereOm3E/RkUgFpMLKfv6/', accessKey: 'AKIAZADLXOUB3433QRUY');


// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  // final String imagePath;
  final imageBytes;

  const DisplayPictureScreen({Key? key, required this.imageBytes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.memory(imageBytes), // Image.file(File(imagePath)),
    );
  }
}
