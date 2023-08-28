import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';

class Helpers {
  static Future<FilePickerResult?> pickImages() async => await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );

  static Future<ui.Image> generateThumnail(ui.Image img) async {
    final list = await img.toUint8List();

    return bytesToImage(await FlutterImageCompress.compressWithList(
      list,
      minHeight: (img.height / 2).floor(),
      minWidth: (img.width / 2).floor(),
      quality: 96,
    ));
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
