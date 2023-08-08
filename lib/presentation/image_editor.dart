import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:furnai/misc/enums.dart';
import 'package:furnai/painters/image_editor_painter.dart';
import 'dart:ui' as ui;

import 'package:furnai/painters/image_mask_painter.dart';

class ImageEditorView extends StatefulWidget {
  const ImageEditorView({super.key, required this.image});
  final ui.Image image;
  @override
  State<ImageEditorView> createState() => ImageEditorViewState();
}

class ImageEditorViewState extends State<ImageEditorView> {
  List<Offset?> _points = [];
  Offset _imageOffset = Offset.zero;
  Offset _initialImageOffset = Offset.zero;
  PointerMode _pointerMode = PointerMode.none;

  // [CustomPainter] has its own @canvas to pass our
  // [ui.PictureRecorder] object must be passed to [Canvas]#contructor
  // to capture the Image. This way we can pass @recorder to [Canvas]#contructor
  // using @painter[SignaturePainter] we can call [SignaturePainter]#paint
  // with the our newly created @canvas
  Future<ui.Image> get mask async {
    var size = Size(widget.image.width.toDouble(), widget.image.height.toDouble());
    var maskRecorder = ui.PictureRecorder();
    var maskCanvas = Canvas(maskRecorder);
    ImageMaskPainter maskPainter = ImageMaskPainter(
      imageSize: size,
      points: _points,
    );
    maskPainter.paint(maskCanvas, size);
    return maskRecorder.endRecording().toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.amber,
      child: Listener(
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
        child: MouseRegion(
          cursor: switch (_pointerMode) {
            PointerMode.sketch => SystemMouseCursors.precise,
            PointerMode.drag => SystemMouseCursors.move,
            PointerMode.none => SystemMouseCursors.basic
          },
          child: CustomPaint(
            size: Size(widget.image.width.toDouble(), widget.image.height.toDouble()),
            painter: ImageEditorPainter(image: widget.image, points: _points, offsetFromOrigin: _imageOffset),
          ),
        ),
      ),
    );
  }
}
