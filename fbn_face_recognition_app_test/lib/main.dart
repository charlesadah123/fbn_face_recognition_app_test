import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Use null-safe File variable
  File? _imageFile;
  // List to store detected faces
  List<Face> _faces = [];

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _detectFaces(
            _imageFile!); // Call face detection function after image selection
      }
    });
  }

  // Function to detect faces using Google ML Kit
  Future<void> _detectFaces(File imageFile) async {
    // Initialize the FaceDetector instance (optional for customization)
    final options = FaceDetectorOptions(
      // Adjust performance/accuracy options
      enableContours: true, // Enable face contour detection (optional)
      // Enable facial landmarks (optional)
    );
    final faceDetector = FaceDetector(options: options);

    // Create an InputImage object from the picked image
    final inputImage = InputImage.fromFilePath(imageFile.path);

    // Perform face detection
    final faces = await faceDetector.processImage(inputImage);

    // Print information about detected faces to the console
    if (faces.isNotEmpty) {
      print('${faces.length} face(s) detected:');
      for (int i = 0; i < faces.length; i++) {
        print('Face $i:');
        print('Bounding Box: ${faces[i].boundingBox}');
        // You can print other properties of the Face object as well
      }
    } else {
      print('No faces detected rigt no.');
    }

    // Update state with detected faces
    setState(() {
      _faces = faces;
      if (_faces.isNotEmpty) {
        print('face has been set');
      } else
        print('no face detected');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pick Image and Detect Faces'),
        ),
        body: Stack(
          // Use Stack to combine image and bounding boxes (optional)
          children: [
            CustomPaint(
              // Optional: Draw bounding boxes on top of the image
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: (_faces.isNotEmpty) ? FacePainter(_faces) : null,
            ),
            Center(
              child: _imageFile != null
                  ? Image.file(_imageFile!) // Use null-safe access
                  : Text('No image selected'),
            ),
            
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _pickImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.photo_library),
        ),
      ),
    );
  }
}

// Custom painter class to draw bounding boxes (optional)
class FacePainter extends CustomPainter {
  final List<Face> faces;

  FacePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    print('FacePainter.paint called!');
    _drawBoundingBoxes(canvas, size); // Call the _drawBoundingBoxes method
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) => oldDelegate.faces != faces;

  // Define the _drawBoundingBoxes method to draw bounding boxes around detected faces
  void _drawBoundingBoxes(Canvas canvas, Size imageSize) {
    if (faces.isEmpty) {
      print(" not drawing");
      return;
    }

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (final face in faces) {
      final rect = face.boundingBox;
      final scaledRect = Rect.fromLTRB(
          rect.left * imageSize.width,
          rect.top * imageSize.height,
          rect.width * imageSize.width,
          rect.height * imageSize.height);
      canvas.drawRect(scaledRect, paint);
    }
  }
}
