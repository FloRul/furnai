import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class EditImagePage extends StatefulWidget {
  const EditImagePage({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  late ui.Image original;
  late ui.Image edited;
  bool isImageLoaded = false;
  GlobalKey<ImageDrawViewState> imageEditorKey = GlobalKey();

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
      body: isImageLoaded
          ? ImageDrawView(
              key: imageEditorKey,
              image: original,
            )
          : const CircularProgressIndicator(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveImage(
          context,
          (data) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => Scaffold(
                appBar: AppBar(),
                body: Image.memory(Uint8List.view(data.buffer)),
              ),
            ),
          ),
        ),
        child: const Icon(Icons.save),
      ),
    );
  }

  saveImage(BuildContext context, void Function(ByteData data) onSaved) async {
    ui.Image renderedImage = await imageEditorKey.currentState!.rendered;

    print('image ${renderedImage.toString()}');
    setState(() {
      edited = renderedImage;
    });
    var pngBytes = await edited.toByteData(format: ui.ImageByteFormat.png);
    onSaved(pngBytes!);
  }
}

class ImageDrawView extends StatefulWidget {
  const ImageDrawView({super.key, required this.image});
  final ui.Image image;
  @override
  State<ImageDrawView> createState() => ImageDrawViewState();
}

class ImageDrawViewState extends State<ImageDrawView> {
  List<Offset?> _points = [];

  // [CustomPainter] has its own @canvas to pass our
  // [ui.PictureRecorder] object must be passed to [Canvas]#contructor
  // to capture the Image. This way we can pass @recorder to [Canvas]#contructor
  // using @painter[SignaturePainter] we can call [SignaturePainter]#paint
  // with the our newly created @canvas
  Future<ui.Image> get rendered {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    ImageEditor painter = ImageEditor(points: _points, image: widget.image);
    var size = context.size;
    painter.paint(canvas, size!);
    return recorder.endRecording().toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _points = List.from(_points)..add(details.localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) {
        setState(() {
          _points.add(null);
        });
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: ImageEditor(image: widget.image, points: _points),
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
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15.0
      ..blendMode = BlendMode.srcOver;

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
