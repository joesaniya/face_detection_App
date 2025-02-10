import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'dart:ui' as ui;

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainterr extends CustomPainter {
  final List<Face> faces;

  FacePainterr(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    for (var face in faces) {
      final rect = face.boundingBox;
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(FacePainterr oldDelegate) {
    return oldDelegate.faces != faces;
  }
}
