import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImageEditorPainter extends CustomPainter {
  final List<Offset?> points;
  final ui.Image image;
  final Offset offsetFromOrigin;

  ImageEditorPainter({required this.points, required this.image, required this.offsetFromOrigin});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..filterQuality = FilterQuality.high
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0
      ..blendMode = BlendMode.srcOver;
    canvas.drawImage(image, offsetFromOrigin, paint);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]! + offsetFromOrigin, points[i + 1]! + offsetFromOrigin, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ImageEditorPainter oldDelegate) {
    return oldDelegate.points != points || offsetFromOrigin != oldDelegate.offsetFromOrigin;
  }
}
