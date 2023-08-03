import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  late ui.Image original;
  bool isImageLoaded = false;
  List<Offset?> _points = [];
  @override
  void initState() {
    _loadImage();
    super.initState();
  }

  _loadImage() async {
    final ui.Image image = await decodeImageFromList(
      await File(widget.imagePath).readAsBytes(),
    );
    setState(() {
      isImageLoaded = true;
      original = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: isImageLoaded
            ? LayoutBuilder(builder: (_, constraints) {
                return GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox object = _.findRenderObject() as RenderBox;
                      Offset locationPoints = object.localToGlobal(details.globalPosition);
                      _points = List.from(_points)..add(locationPoints);
                    });
                  },
                  onPanEnd: (DragEndDetails details) {
                    setState(() {
                      _points.add(null);
                    });
                  },
                  child: CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: ImageEditor(image: original, points: _points),
                  ),
                );
              })
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class ImageEditor extends CustomPainter {
  // [SignaturePainter] receives points through constructor
  // @points holds the drawn path in the form (x,y) offset;
  // This class responsible for drawing only
  // It won't receive any drag/touch events by draw/user.
  List<Offset?> points = [];
  ui.Image image;

  ImageEditor({required this.points, required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 5.0;

    final outputRect = Rect.fromPoints(ui.Offset.zero, ui.Offset(size.width, size.height));
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes = applyBoxFit(BoxFit.contain, imageSize, outputRect.size);
    final Rect inputSubrect = Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect = Alignment.center.inscribe(sizes.destination, outputRect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ImageEditor oldDelegate) {
    return oldDelegate.points != points;
  }
}
