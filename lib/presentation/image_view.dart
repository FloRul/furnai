import 'package:flutter/material.dart';
import 'package:furnai/misc/enums.dart';
import 'dart:ui' as ui;

import 'package:furnai/presentation/image_editor.dart';
import 'package:furnai/presentation/mask_result_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furnai/services/remote_image_service.dart';

class ImageEditorWrapper extends ConsumerStatefulWidget {
  const ImageEditorWrapper({super.key, required this.image});
  final ui.Image image;

  @override
  ConsumerState<ImageEditorWrapper> createState() => _ImageEditorWrapperState();
}

class _ImageEditorWrapperState extends ConsumerState<ImageEditorWrapper> {
  GlobalKey<ImageEditorViewState> imageEditorKey = GlobalKey<ImageEditorViewState>();
  PointerMode _pointerMode = PointerMode.drag;
  final List<Widget> _pointerModeToggles = [
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(
        Icons.back_hand,
        size: 30,
      ),
    ),
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(
        Icons.draw,
        size: 30,
      ),
    ),
  ];
  late List<bool> _pointerModeSelection;

  @override
  void initState() {
    _pointerModeSelection = List.generate(
      _pointerModeToggles.length,
      (index) => index == 0,
    );
    _pointerMode = PointerMode.drag;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(100),
            constrained: false,
            panEnabled: _pointerMode == PointerMode.drag,
            child: ImageEditorView(
              key: imageEditorKey,
              image: widget.image,
              pointerMode: _pointerMode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                IconButton.filledTonal(
                  iconSize: 30,
                  onPressed: () async {
                    var mask = await imageEditorKey.currentState!.mask;
                    await ref
                        .read(remoteImageServiceProvider.notifier)
                        .uploadImages(
                          original: widget.image,
                          mask: mask,
                        )
                        .then(
                          (value) => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MaskResultPreview(
                                original: widget.image,
                                mask: mask,
                              ),
                            ),
                          ),
                        );
                  },
                  icon: const Icon(Icons.save),
                ),
                const SizedBox(
                  height: 8,
                ),
                ToggleButtons(
                  direction: Axis.vertical,
                  isSelected: _pointerModeSelection,
                  children: _pointerModeToggles,
                  onPressed: (index) {
                    setState(() {
                      _pointerMode = switch (index) {
                        0 => PointerMode.drag,
                        1 => PointerMode.sketch,
                        _ => PointerMode.none,
                      };
                      for (int i = 0; i < _pointerModeSelection.length; i++) {
                        _pointerModeSelection[i] = i == index;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
