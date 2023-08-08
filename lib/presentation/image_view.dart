import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:furnai/misc/enums.dart';
import 'dart:ui' as ui;

import 'package:furnai/presentation/image_editor.dart';
import 'package:furnai/presentation/mask_result_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageEditorWrapper extends StatefulWidget {
  const ImageEditorWrapper({super.key, required this.image});
  final ui.Image image;

  @override
  State<ImageEditorWrapper> createState() => _ImageEditorWrapperState();
}

class _ImageEditorWrapperState extends State<ImageEditorWrapper> {
  GlobalKey<ImageEditorViewState> imageEditorKey = GlobalKey();
  PointerMode _pointerMode = PointerMode.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ImageEditorView(
            key: imageEditorKey,
            image: widget.image,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveImage(
          (data) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MaskResultPreview(result: data),
            ),
          ),
        ),
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<void> saveImage(void Function((ByteData, ByteData) saved) onSaved) async {
    var mask = await imageEditorKey.currentState!.mask;

    var originalPngBytes = await widget.image.toByteData(format: ui.ImageByteFormat.png);
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
