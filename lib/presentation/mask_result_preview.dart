import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MaskResultPreview extends StatelessWidget {
  const MaskResultPreview({
    super.key,
    required this.original,
    required this.mask,
  });

  final ui.Image original;
  final ui.Image mask;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text(
            'Image and mask saved!',
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
            child: RawImage(
              image: original,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: RawImage(
              image: mask,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }
}
