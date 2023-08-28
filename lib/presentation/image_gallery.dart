import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furnai/helpers/pick_file.dart';
import 'package:furnai/presentation/image_view.dart';
import 'package:furnai/presentation/widgets/image_thumbnail.dart';
import 'dart:ui' as ui;

import 'package:furnai/presentation/widgets/loading_overlay.dart';
import 'package:furnai/services/remote_image_service.dart';

class ImageGallery extends ConsumerStatefulWidget {
  const ImageGallery({super.key});

  @override
  ConsumerState<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends ConsumerState<ImageGallery> {
  final List<String> _gallery = [];
  late Map<String, bool> _hovered;
  late bool _isDeleting;

  @override
  void initState() {
    _isDeleting = false;
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
        title: const Text('FurnAI'),
        actions: [
          IconButton(
            isSelected: _isDeleting,
            icon: const Icon(Icons.delete_outline),
            selectedIcon: const Icon(Icons.delete),
            onPressed: () => setState(() {
              _isDeleting = !_isDeleting;
            }),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Amplify.Auth.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
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
                  child: ImageThumbnail(
                    isChecked: _isDeleting ? false : null,
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

                      await Future.delayed(const Duration(milliseconds: 500));
                      overlayEntry.remove();

                      // ignore: use_build_context_synchronously
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
            Expanded(
              child: ref.watch(remoteImageServiceProvider).when(
                    data: (entries) => ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (_, index) => ListTile(title: Text(entries[index].id)),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stackTrace) => Text(error.toString()),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'pickFile',
        onPressed: () async {
          var result = await Helpers.pickImages();
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
