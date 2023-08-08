import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:furnai/painters/image_editor_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  late ui.Image _original;
  late ui.Image _edited;
  bool _isImageLoaded = false;
  GlobalKey<ImageDrawViewState> imageEditorKey = GlobalKey();
  PointerMode _pointerMode = PointerMode.none;

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
      _isImageLoaded = true;
      _original = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isImageLoaded
          ? Stack(
              children: [
                ImageDrawView(
                  key: imageEditorKey,
                  image: _original,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        heroTag: 'sketch',
                        onPressed: () => setState(() {
                          _pointerMode = PointerMode.sketch;
                        }),
                        child: const Icon(Icons.draw),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        heroTag: 'drag',
                        onPressed: () => setState(() {
                          _pointerMode = PointerMode.drag;
                        }),
                        child: const Icon(Icons.back_hand),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveImage(
          context,
          (data) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => Scaffold(
                appBar: AppBar(),
                body: Row(
                  children: [
                    Expanded(
                      child: Image.memory(
                        Uint8List.view(data.$1.buffer),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                      child: Image.memory(
                        Uint8List.view(data.$2.buffer),
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        child: const Icon(Icons.save),
      ),
    );
  }

// TODO refactor to remove context coupling
  Future<void> saveImage(BuildContext context, void Function((ByteData, ByteData) saved) onSaved) async {
    var mask = await imageEditorKey.currentState!.mask;

    var originalPngBytes = await _original.toByteData(format: ui.ImageByteFormat.png);
    var maskPngBytes = await mask.toByteData(format: ui.ImageByteFormat.png);

    final buffer = originalPngBytes!.buffer;
    final maskBuffer = maskPngBytes!.buffer;

    const uuid = Uuid();

    var dir = await getApplicationDocumentsDirectory();
    var originalPath = '${dir.path}\\generated\\${uuid.v1()}.png';
    var maskPath = '${dir.path}\\generated\\${uuid.v1()}_mask.png';

    File(originalPath).create(recursive: true).then((file) =>
        file.writeAsBytes(buffer.asUint8List(originalPngBytes.offsetInBytes, originalPngBytes.lengthInBytes)));
    File(maskPath).create(recursive: true).then(
        (file) => file.writeAsBytes(maskBuffer.asUint8List(maskPngBytes.offsetInBytes, maskPngBytes.lengthInBytes)));
    onSaved((originalPngBytes, maskPngBytes));
  }
}
