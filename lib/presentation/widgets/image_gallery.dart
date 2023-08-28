import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furnai/presentation/widgets/interactive_thumbnail.dart';
import 'package:furnai/services/get_thumbnail.dart';
import 'package:furnai/services/remote_image_service.dart';

class ImageGallery extends ConsumerStatefulWidget {
  const ImageGallery({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends ConsumerState<ImageGallery> {
  @override
  Widget build(BuildContext context) {
    ref
        .read(remoteImageServiceProvider.notifier)
        .entryUpdate
        .listen((event) => ref.refresh(remoteImageServiceProvider));

    return ref.watch(remoteImageServiceProvider).when(
          data: (data) {
            return GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 128),
              itemBuilder: (_, index) {
                // return Text(_entries[index].id);
                return ref.watch(thumbnailByIdProvider(data[index]!.id)).when(
                      data: (data) => InteractiveThumbnail.rawImage(img: data!),
                      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
                      error: (error, stackTrace) => Center(child: Text(error.toString())),
                    );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
        );
  }
}
