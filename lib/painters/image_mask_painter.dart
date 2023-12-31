﻿import 'package:flutter/material.dart';

class ImageMaskPainter extends CustomPainter {
  final List<Offset?> points;
  final Size imageSize;

  ImageMaskPainter({
    required this.points,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, imageSize.width, imageSize.height), paint);

    paint
      ..color = Colors.white
      ..filterQuality = FilterQuality.high
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0
      ..blendMode = BlendMode.srcOver;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ImageMaskPainter oldDelegate) => false;
}
