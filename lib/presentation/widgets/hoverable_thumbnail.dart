import 'dart:io';

import 'package:flutter/material.dart';

class HoverableThumbnail extends StatelessWidget {
  const HoverableThumbnail({
    super.key,
    required this.hovered,
    required this.path,
    this.onTapUp,
  });

  final bool hovered;
  final String path;
  final void Function(String path)? onTapUp;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: hovered ? 1.2 : 1,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTapUp: (details) => onTapUp?.call(path),
        child: Image.file(
          File(path),
        ),
      ),
    );
  }
}
