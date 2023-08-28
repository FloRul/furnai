import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:furnai/helpers/image_helpers.dart';
import 'package:furnai/misc/constants.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:ui';
part 'get_thumbnail.g.dart';

@riverpod
Future<Image?> thumbnailById(ThumbnailByIdRef ref, String entryId) async {
  try {
    var result = await Amplify.Storage.downloadData(
        key: '${KeyPrefix.thumbnail}/$entryId',
        options: const StorageDownloadDataOptions(
          accessLevel: StorageAccessLevel.private,
        )).result;
    safePrint('fetched : $entryId');
    return Helpers.bytesToImage(result.bytes as Uint8List);
  } on ApiException catch (e) {
    safePrint('Query failed: $e');
    return null;
  }
}
