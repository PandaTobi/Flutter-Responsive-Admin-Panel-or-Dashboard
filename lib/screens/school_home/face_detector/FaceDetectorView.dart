import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as rek;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'camera_view.dart';
import 'painters/face_detector_painter.dart';

class FaceDetectorView extends StatefulWidget {

  @override
  _FaceDetectorViewState createState() => _FaceDetectorViewState();
  static String image_path = _FaceDetectorViewState.imagePath;

}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  static String imagePath = "";
  static bool faceDetected = false;
  bool keepScreenshotting = true;

  FaceDetector faceDetector =
  GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: false,
    enableClassification: true,
  ));
  bool isBusy = false;
  CustomPaint? customPaint;

  @override
  dispose() async {
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CameraView(
      title: 'Face Detector',
      customPaint: customPaint,
      onImage: (inputImage) {

        processImage(inputImage);



        // TODO: if face, grab input image
      },
      onRegImage: (regImage) {
        print("FOUND FACE FACE FACE 1984");

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              imagePath: regImage,
            ),
          ),
        );
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) {
      return;
    }
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    print('Found ${faces.length} faces');
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);

      if (faces.length > 0) {
        faceDetected = true;
      }

      print("this is running");

      // if (faces.length > 0) {
      //   if (keepScreenshotting) {
      //     takeScreenShot();
      //     keepScreenshotting = false;
      //
      //     // TODO: turn keeepScreenshotting into an array of faces detected
      //   }
      //
      //   // TODO: stop after one
      // }

    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }

  }

  // Future<void> takeScreenShot() async {
  //
  //   String? path = await NativeScreenshot.takeScreenshot();
  //   debugPrint('Screenshot taken, path: $path');
  //
  //
  //   // redirect to page displaying image
  //   if (path != null) {
  //     imagePath = path as String;
  //   }
  //
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => DisplayPictureScreen(
  //         imagePath: imagePath,
  //       ),
  //     ),
  //   );
  // }
}

class DisplayPictureScreen extends StatefulWidget {
  final Image imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

var credentials = rek.AwsClientCredentials(secretKey: '4tHP09vwWbnvlHtYmJzereOm3E/RkUgFpMLKfv6/', accessKey: 'AKIAZADLXOUB3433QRUY');

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  var service = rek.Rekognition(region: 'us-west-1', credentials: credentials);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload The Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
          children: [
            Expanded(
                child: widget.imagePath //Image.file(File(_FaceDetectorViewState.imagePath))
            ),
            ElevatedButton(
                onPressed: () async {
                  // how to create a collection
                  ByteData bytes = await rootBundle.load(_FaceDetectorViewState.imagePath);
                  // File file = await getImageFileFromAssets('assets/images/yutest.jpeg');
                  // Uint8List bytes = file.readAsBytesSync();
                  var image = rek.Image(bytes: bytes.buffer.asUint8List());
                  service.indexFaces(collectionId: "andyproject", image: image, externalImageId: "user-yu")
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
                child: Text("Is this face in?"),
                onPressed: () async {
                  print("button pressed");

                  File file = File(_FaceDetectorViewState.imagePath);
                  Uint8List bytes = file.readAsBytesSync();
                  var image = rek.Image(bytes: bytes);

                  print("button pressed");

                  service.searchFacesByImage(collectionId: "andyproject", image: image)
                      .then((value) {
                    print("Successfully found the image.");
                    print(value.faceMatches?.first.face?.externalImageId);
                  }).catchError((e) {
                    print("Failed to find the image.");
                    print(e);
                  });
                }
            )
          ]
      ),
    );
  }
}

