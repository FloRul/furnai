import 'dart:io';

import 'package:flutter/material.dart';

class ImageThumbnail extends StatefulWidget {
  const ImageThumbnail({
    super.key,
    required this.hovered,
    required this.path,
    this.isChecked,
    this.onTapUp,
  });

  final bool? isChecked;
  final bool hovered;
  final String path;
  final void Function(String path)? onTapUp;

  @override
  State<ImageThumbnail> createState() => _ImageThumbnailState();
}

class _ImageThumbnailState extends State<ImageThumbnail> {
  late bool? _isChecked;

  @override
  void initState() {
    _isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.hovered ? 1.2 : 1,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTapUp: (details) => widget.onTapUp?.call(widget.path),
        child: Stack(
          children: [
            Visibility(
                visible: widget.isChecked != null,
                child: Checkbox(
                  tristate: true,
                  value: _isChecked,
                  onChanged: (value) => _isChecked = value,
                )),
            Image.file(
              File(widget.path),
            ),
          ],
        ),
      ),
    );
  }
}
