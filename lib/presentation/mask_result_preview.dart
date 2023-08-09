import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MaskResultPreview extends StatelessWidget {
  const MaskResultPreview({
    super.key,
    required this.result,
    required this.path,
  });

  final (ByteData, ByteData) result;
  final String path;
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            'Image and mask saved under $path',
          ),
        ),
      ),
    );

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
