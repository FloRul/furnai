import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furnai/image_view.dart';

class HoverableThumbnail extends StatelessWidget {
  const HoverableThumbnail({
    super.key,
    required this.hovered,
    required this.path,
  });

  final bool hovered;
  final String path;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: hovered ? 1.2 : 1,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTapUp: (details) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditImagePage(imagePath: path),
          ),
        ),
        child: Image.file(
          File(path),
        ),
      ),
    );
  }
}
