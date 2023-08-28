import 'dart:io';
import 'dart:typed_data';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:furnai/helpers/pick_file.dart';
import 'package:furnai/misc/constants.dart';

import 'package:furnai/models/ImageEntry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;

part 'remote_image_service.g.dart';

@riverpod
class RemoteImageService extends _$RemoteImageService {
  Future<List<ImageEntry>> fetchImageEntry() async {
    try {
      final request = ModelQueries.list(ImageEntry.classType);
      final response = await Amplify.API.query(request: request).response;
      final entries = response.data?.items;
      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return [];
      }
      return entries!.whereType<ImageEntry>().toList();
    } catch (e) {
      safePrint('Query failed: $e');
      rethrow;
    }
  }

  @override
  FutureOr<List<ImageEntry>> build() async => fetchImageEntry();

  Future<void> uploadImages({
    required ui.Image original,
    required ui.Image mask,
    String contentType = 'image/png',
  }) async {
    try {
      const uuid = Uuid();
      final entryId = uuid.v1();

      final originalId = '${KeyPrefix.original}/$entryId';
      final maskId = '${KeyPrefix.mask}/$entryId';
      final thumnailId = '${KeyPrefix.thumbnail}/$entryId';

      var originalPngBytes = await original.toUint8List();
      var maskPngBytes = await mask.toUint8List();

      Amplify.Storage.uploadData(
          options: const StorageUploadDataOptions(accessLevel: StorageAccessLevel.private),
          data: S3DataPayload.bytes(originalPngBytes, contentType: contentType),
          key: originalId);

      Amplify.Storage.uploadData(
          options: const StorageUploadDataOptions(accessLevel: StorageAccessLevel.private),
          data: S3DataPayload.bytes(maskPngBytes, contentType: contentType),
          key: maskId);

      final thumbnail = await Helpers.generateThumnail(original);
      var thumbnailPngBytes = await thumbnail.toUint8List();

      Amplify.Storage.uploadData(
          options: const StorageUploadDataOptions(accessLevel: StorageAccessLevel.private),
          data: S3DataPayload.bytes(thumbnailPngBytes, contentType: contentType),
          key: thumnailId);

      final entry =
          ImageEntry(id: uuid.v1(), originalImagePath: originalId, maskImagePath: maskId, thumnailPath: thumnailId);
      await Amplify.API.mutate(request: ModelMutations.create(entry)).response;
    } on StorageException catch (e) {
      safePrint('Error uploading data: ${e.message}');
      rethrow;
    }
  }

  Future<List<ImageEntry?>> getEntryThumnails([int limit = 50]) async {
    try {
      final request = ModelQueries.list(ImageEntry.classType);
      final response = await Amplify.API.query(request: request).response;

      final entries = response.data?.items;
      if (entries == null) {
        safePrint('errors: ${response.errors}');
        return const [];
      }
      return entries;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return const [];
    }
  }

  Future<void> saveImageLocally(
      ui.Image original, ui.Image mask, void Function((ByteData, ByteData) saved, String path) onSaved) async {
    var originalPngBytes = await original.toByteData(format: ui.ImageByteFormat.png);
    var maskPngBytes = await mask.toByteData(format: ui.ImageByteFormat.png);

    final buffer = originalPngBytes!.buffer;
    final maskBuffer = maskPngBytes!.buffer;

    const uuid = Uuid();

    var dir = await getApplicationDocumentsDirectory();
    var folderPath = '${dir.path}\\generated';
    var originalPath = '$folderPath\\${uuid.v1()}.png';
    var maskPath = '$folderPath\\${uuid.v1()}_mask.png';

    File(originalPath).create(recursive: true).then((file) =>
        file.writeAsBytes(buffer.asUint8List(originalPngBytes.offsetInBytes, originalPngBytes.lengthInBytes)));
    File(maskPath).create(recursive: true).then(
        (file) => file.writeAsBytes(maskBuffer.asUint8List(maskPngBytes.offsetInBytes, maskPngBytes.lengthInBytes)));
    onSaved((originalPngBytes, maskPngBytes), folderPath);
  }
}
