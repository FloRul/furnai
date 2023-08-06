import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:furnai/image_editing.dart';
import 'package:path_provider/path_provider.dart';

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
                        onPressed: () => setState(() {
                          _pointerMode = PointerMode.sketch;
                        }),
                        child: const Icon(Icons.draw),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
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
                body: Center(child: Image.memory(Uint8List.view(data.buffer))),
              ),
            ),
          ),
        ),
        child: const Icon(Icons.save),
      ),
    );
  }

// TODO refactor to remove context coupling
  Future<void> saveImage(BuildContext context, void Function(ByteData data) onSaved) async {
    ui.Image renderedImage = await imageEditorKey.currentState!.rendered;
    setState(() {
      _edited = renderedImage;
    });
    var pngBytes = await _edited.toByteData(format: ui.ImageByteFormat.png);
    final buffer = pngBytes!.buffer;
    var dir = await getApplicationDocumentsDirectory();
    var path = '${dir.path}\\generated\\IMG01.png';
    print(path);
    File(path).writeAsBytes(buffer.asUint8List(pngBytes.offsetInBytes, pngBytes.lengthInBytes));
    onSaved(pngBytes);
  }
}
