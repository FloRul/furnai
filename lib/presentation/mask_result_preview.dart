import 'dart:typed_data';

import 'package:flutter/material.dart';

class MaskResultPreview extends StatelessWidget {
  const MaskResultPreview({
    super.key,
    required this.result,
  });

  final (ByteData, ByteData) result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
            child: Image.memory(
              Uint8List.view(result.$1.buffer),
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Image.memory(
              Uint8List.view(result.$2.buffer),
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }
}
