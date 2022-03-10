import 'package:camera/camera.dart';
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

class FaceDetectorView extends StatefulWidget {
  @override
  _FaceDetectorViewState createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  FaceDetector faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: false,
    enableClassification: true,
  ));
  bool isBusy = false;
  CustomPaint? customPaint;

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face Detector',
      customPaint: customPaint,
      onImage: (inputImage, image) {
        processImage(inputImage, image);
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  Future<void> processImage(InputImage inputImage, CameraImage? image) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    print('Found ${faces.length} faces');
    print('Found test yusun');
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
    if (faces.length > 0) {
      print("Found here!");
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      var filePath = tempPath + '/file_01.jpeg';

      List<int>? imageBytes = await convertImagetoPng(image!);

      File imageFile = await File(filePath).writeAsBytes(imageBytes!);
      print(imageFile.path);

      faceDetector.close();
      super.dispose();

      GallerySaver.saveImage(filePath).then((success) {
        setState(() {
          print('Image is saved');
        });
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => idv.DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imageBytes: imageBytes!, //. imageFile.path,
          ),
        ),
      );



      print(await imageFile.length());
    }
  }

  Future<List<int>?> convertImagetoPng(CameraImage image) async {
    try {
      imglib.Image img = imglib.Image(100, 100);
      if (image.format.group == ImageFormatGroup.yuv420) {
        print("YUV420 GROUP");
        img = _convertYUV420(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        print("BGRA8888 GROUP");
        img = _convertBGRA8888(image);
      }

      imglib.PngEncoder pngEncoder = new imglib.PngEncoder();

      // Convert to png
      List<int> png = pngEncoder.encodeImage(img);
      return png;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

// CameraImage BGRA8888 -> PNG
// Color
  imglib.Image _convertBGRA8888(CameraImage image) {
    return imglib.Image.fromBytes(
      image.width,
      image.height,
      image.planes[0].bytes,
      format: imglib.Format.bgra,
    );
  }

// CameraImage YUV420_888 -> PNG -> Image (compresion:0, filter: none)
// Black
  imglib.Image _convertYUV420(CameraImage image) {
    var img = imglib.Image(image.width, image.height); // Create Image buffer

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0;
      planeOffset < image.height * image.width;
      planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        var newVal = shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        img.data[planeOffset + x] = newVal;
      }
    }

    return img;
  }
}
