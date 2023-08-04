﻿import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImageDrawView extends StatefulWidget {
  const ImageDrawView({super.key, required this.image});
  final ui.Image image;
  @override
  State<ImageDrawView> createState() => ImageDrawViewState();
}

enum PointerMode { sketch, drag, none }

class ImageDrawViewState extends State<ImageDrawView> {
  List<Offset?> _points = [];
  Offset _imageOffset = Offset.zero;
  Offset _initialImageOffset = Offset.zero;
  PointerMode _pointerMode = PointerMode.none;

  // [CustomPainter] has its own @canvas to pass our
  // [ui.PictureRecorder] object must be passed to [Canvas]#contructor
  // to capture the Image. This way we can pass @recorder to [Canvas]#contructor
  // using @painter[SignaturePainter] we can call [SignaturePainter]#paint
  // with the our newly created @canvas
  Future<ui.Image> get rendered {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    ImageEditor painter = ImageEditor(points: _points, image: widget.image, offsetFromOrigin: _imageOffset);
    var size = context.size;
    painter.paint(canvas, size!);
    return recorder.endRecording().toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        switch (event.buttons) {
          case kPrimaryButton:
            setState(() => _pointerMode = PointerMode.sketch);
          case kTertiaryButton:
            setState(() => _pointerMode = PointerMode.drag);
          default:
            setState(() => _pointerMode = PointerMode.none);
        }
      },
      onPointerMove: (event) {
        switch (_pointerMode) {
          case PointerMode.sketch:
            setState(() => _points = List.from(_points)..add(event.localPosition - _imageOffset));
          case PointerMode.drag:
            setState(() => _imageOffset = _initialImageOffset += event.delta);
          default:
        }
      },
      onPointerUp: (event) {
        switch (_pointerMode) {
          case PointerMode.sketch:
            setState(() => _points.add(null));
          case PointerMode.drag:
            setState(() => _initialImageOffset = _imageOffset);
          default:
        }
        _pointerMode = PointerMode.none;
      },
      child: Builder(builder: (context) {
        return MouseRegion(
          cursor: switch (_pointerMode) {
            PointerMode.sketch => SystemMouseCursors.precise,
            PointerMode.drag => SystemMouseCursors.move,
            PointerMode.none => SystemMouseCursors.basic
          },
          child: CustomPaint(
            size: Size(widget.image.width.toDouble(), widget.image.height.toDouble()),
            painter: ImageEditor(image: widget.image, points: _points, offsetFromOrigin: _imageOffset),
          ),
        );
      }),
    );
  }
}

class ImageEditor extends CustomPainter {
  // [ImageEditor] receives points through constructor
  // @points holds the drawn path in the form (x,y) offset;
  // This class responsible for drawing only
  // It won't receive any drag/touch events by draw/user.
  final List<Offset?> points;
  final ui.Image image;
  final Offset offsetFromOrigin;

  ImageEditor({required this.points, required this.image, required this.offsetFromOrigin});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..filterQuality = FilterQuality.high
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15.0
      ..blendMode = BlendMode.srcOver;
    canvas.drawImage(image, offsetFromOrigin, paint);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]! + offsetFromOrigin, points[i + 1]! + offsetFromOrigin, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ImageEditor oldDelegate) {
    return oldDelegate.points != points || offsetFromOrigin != oldDelegate.offsetFromOrigin;
  }
}
