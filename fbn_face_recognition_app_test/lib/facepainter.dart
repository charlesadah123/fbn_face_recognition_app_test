// Custom painter class to draw bounding boxes (optional)
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

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