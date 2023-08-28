import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart';

class Helpers {
  static Future<ui.Image> generateThumnail(ui.Image img) async {
    // final list = await img.toUint8List();
    // final bytes = await FlutterImageCompress.compressWithList(
    //   list,
    //   minHeight: (img.height / 2).floor(),
    //   minWidth: (img.width / 2).floor(),
    //   quality: 96,
    // );
    // return decodeImageFromList(bytes);
    return img;
  }

  static Future<ui.Image> getImage() async {
    final completer = Completer<ui.Image>();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
      final file = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (file != null) {
        final filePath = file.files.single.path;
        final bytes = filePath == null ? file.files.first.bytes : File(filePath).readAsBytesSync();
        if (bytes != null) {
          completer.complete(decodeImageFromList(bytes));
        } else {
          completer.completeError('No image selected');
        }
      }
    } else {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        completer.complete(
          decodeImageFromList(bytes),
        );
      } else {
        completer.completeError('No image selected');
      }
    }
    return completer.future;
  }

  static Future<ui.Image> bytesToImage(Uint8List imgBytes) async {
    ui.Codec codec = await ui.instantiateImageCodec(imgBytes);
    ui.FrameInfo frame;
    try {
      frame = await codec.getNextFrame();
    } finally {
      codec.dispose();
    }
    return frame.image;
  }
}

extension ImgX on ui.Image {
  Future<Uint8List> toUint8List([ui.ImageByteFormat format = ui.ImageByteFormat.png]) async {
    var bytes = await toByteData(format: format);
    final buffer = bytes!.buffer;
    return buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
