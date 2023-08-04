import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:furnai/image_editing.dart';

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
    setState(() {
      edited = renderedImage;
    });
    var pngBytes = await edited.toByteData(format: ui.ImageByteFormat.png);
    onSaved(pngBytes!);
  }
}
