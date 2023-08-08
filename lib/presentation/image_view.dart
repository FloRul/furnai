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
  GlobalKey<ImageEditorViewState> imageEditorKey = GlobalKey<ImageEditorViewState>();
  PointerMode _pointerMode = PointerMode.drag;
  final List<Widget> _pointerModeToggles = [
    const Icon(Icons.back_hand),
    const Icon(Icons.draw),
  ];
  late List<bool> _pointerModeSelection;

  @override
  void initState() {
    _pointerModeSelection = List.generate(
      _pointerModeToggles.length,
      (index) => index == 0,
    );
    _pointerMode = PointerMode.drag;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          InteractiveViewer(
            constrained: false,
            panEnabled: _pointerMode == PointerMode.drag,
            child: ImageEditorView(
              key: imageEditorKey,
              image: widget.image,
              pointerMode: _pointerMode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                IconButton.filledTonal(
                  onPressed: () => saveImage(
                    (data) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MaskResultPreview(result: data),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                ),
                const SizedBox(
                  height: 8,
                ),
                ToggleButtons(
                  direction: Axis.vertical,
                  isSelected: _pointerModeSelection,
                  children: _pointerModeToggles,
                  onPressed: (index) {
                    setState(() {
                      _pointerMode = switch (index) {
                        0 => PointerMode.sketch,
                        1 => PointerMode.drag,
                        _ => PointerMode.none,
                      };
                      for (int i = 0; i < _pointerModeSelection.length; i++) {
                        _pointerModeSelection[i] = i == index;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
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
