import 'package:flutter/material.dart';
import 'package:furnai/misc/enums.dart';
import 'package:furnai/painters/image_editor_painter.dart';
import 'dart:ui' as ui;

import 'package:furnai/painters/image_mask_painter.dart';

class ImageEditorView extends StatefulWidget {
  const ImageEditorView({
    super.key,
    required this.image,
    required this.pointerMode,
  });
  final ui.Image image;
  final PointerMode pointerMode;
  @override
  State<ImageEditorView> createState() => ImageEditorViewState();
}

class ImageEditorViewState extends State<ImageEditorView> {
  List<Offset?> _points = [];
  final Offset _imageOffset = Offset.zero;

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
    return Listener(
      onPointerMove: (event) {
        switch (widget.pointerMode) {
          case PointerMode.sketch:
            setState(() => _points = List.from(_points)..add(event.localPosition - _imageOffset));
          default:
        }
      },
      onPointerUp: (event) {
        switch (widget.pointerMode) {
          case PointerMode.sketch:
            setState(() => _points.add(null));
          default:
        }
      },
      child: MouseRegion(
        cursor: switch (widget.pointerMode) {
          PointerMode.sketch => SystemMouseCursors.precise,
          PointerMode.drag => SystemMouseCursors.move,
          PointerMode.none => SystemMouseCursors.basic
        },
        child: CustomPaint(
          size: Size(widget.image.width.toDouble(), widget.image.height.toDouble()),
          painter: ImageEditorPainter(image: widget.image, points: _points, offsetFromOrigin: _imageOffset),
        ),
      ),
    );
  }
}
