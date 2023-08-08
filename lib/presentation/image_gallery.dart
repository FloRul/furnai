import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:furnai/presentation/image_view.dart';
import 'package:furnai/presentation/widgets/hoverable_thumbnail.dart';
import 'dart:ui' as ui;

import 'package:furnai/presentation/widgets/loading_overlay.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key, required this.title});

  final String title;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final List<String> _gallery = [];
  late Map<String, bool> _hovered;

  @override
  void initState() {
    _hovered = Map.fromEntries(
      _gallery.map(
        (e) => MapEntry(e, false),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.builder(
          itemCount: _gallery.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 128),
          itemBuilder: (_, index) => MouseRegion(
            onHover: (event) => setState(() {
              _hovered[_gallery[index]] = true;
            }),
            onExit: (event) => setState(() {
              _hovered[_gallery[index]] = false;
            }),
            child: HoverableThumbnail(
              hovered: _hovered[_gallery[index]]!,
              path: _gallery[index],
              onTapUp: (path) async {
                var overlayEntry = OverlayEntry(builder: (context) => const LoadingOverlay());
                Overlay.of(context).insert(
                  overlayEntry,
                );

                final ui.Image image = await decodeImageFromList(
                  await File(path).readAsBytes(),
                );

                await Future.delayed(const Duration(seconds: 1));
                overlayEntry.remove();

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageEditorWrapper(image: image),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'pickFile',
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'png'],
          );
          final path = result?.paths.firstOrNull;
          if (path != null) {
            setState(() {
              _gallery.add(path);
              _hovered.update(
                path,
                (value) => false,
                ifAbsent: () => false,
              );
            });
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              const SnackBar(
                content: Text(
                  'File picking canceled',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            );
          }
        },
        tooltip: 'Pick file',
        child: const Icon(Icons.file_open),
      ),
    );
  }
}
