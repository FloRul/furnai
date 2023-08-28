import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furnai/helpers/image_helpers.dart';
import 'package:furnai/presentation/image_view.dart';
import 'package:furnai/presentation/widgets/image_gallery.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends ConsumerState<Home> {
  late bool _isDeleting;

  @override
  void initState() {
    _isDeleting = false;
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
      body: const Center(child: ImageGallery()),
      floatingActionButton: FloatingActionButton(
        heroTag: 'pickFile',
        onPressed: () async {
          try {
            var result = await Helpers.getImage();
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageEditorWrapper(
                  image: result,
                ),
              ),
            );
          } catch (e) {
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
