import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class InteractiveThumbnail extends StatefulWidget {
  const InteractiveThumbnail._({
    super.key,
    this.path,
    this.img,
    this.isChecked,
    this.onTapUp,
  });

  factory InteractiveThumbnail.rawImage({
    Key? key,
    required ui.Image img,
    bool? isChecked,
    VoidCallback? onTapUp,
  }) =>
      InteractiveThumbnail._(
        img: img,
        isChecked: isChecked,
        onTapUp: onTapUp,
        key: key,
      );

  factory InteractiveThumbnail.path({
    Key? key,
    bool? hovered,
    required String path,
    bool? isChecked,
    VoidCallback? onTapUp,
  }) =>
      InteractiveThumbnail._(
        path: path,
        isChecked: isChecked,
        onTapUp: onTapUp,
        key: key,
      );

  final bool? isChecked;
  final String? path;
  final ui.Image? img;
  final VoidCallback? onTapUp;

  @override
  State<InteractiveThumbnail> createState() => _InteractiveThumbnailState();
}

class _InteractiveThumbnailState extends State<InteractiveThumbnail> {
  late bool? _isChecked;
  late bool _isHovered;

  @override
  void initState() {
    _isChecked = widget.isChecked;
    _isHovered = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => setState(() {
        _isHovered = true;
      }),
      onExit: (event) => setState(() {
        _isHovered = false;
      }),
      child: AnimatedScale(
        scale: _isHovered ? 1.2 : 1,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTapUp: (details) => widget.onTapUp?.call(),
          child: Stack(
            children: [
              Visibility(
                visible: widget.isChecked != null,
                child: Checkbox(
                  tristate: true,
                  value: _isChecked,
                  onChanged: (value) => _isChecked = value,
                ),
              ),
              widget.path != null
                  ? Image.file(
                      File(widget.path!),
                    )
                  : widget.img != null
                      ? RawImage(
                          image: widget.img!,
                          fit: BoxFit.contain,
                        )
                      : const Placeholder(),
            ],
          ),
        ),
      ),
    );
  }
}
