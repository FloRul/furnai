// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_thumbnail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$thumbnailByIdHash() => r'28ddbedf591e4f27d257a9005cdd2626c29fffb8';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef ThumbnailByIdRef = AutoDisposeFutureProviderRef<Image?>;

/// See also [thumbnailById].
@ProviderFor(thumbnailById)
const thumbnailByIdProvider = ThumbnailByIdFamily();

/// See also [thumbnailById].
class ThumbnailByIdFamily extends Family<AsyncValue<Image?>> {
  /// See also [thumbnailById].
  const ThumbnailByIdFamily();

  /// See also [thumbnailById].
  ThumbnailByIdProvider call(
    String entryId,
  ) {
    return ThumbnailByIdProvider(
      entryId,
    );
  }

  @override
  ThumbnailByIdProvider getProviderOverride(
    covariant ThumbnailByIdProvider provider,
  ) {
    return call(
      provider.entryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'thumbnailByIdProvider';
}

/// See also [thumbnailById].
class ThumbnailByIdProvider extends AutoDisposeFutureProvider<Image?> {
  /// See also [thumbnailById].
  ThumbnailByIdProvider(
    this.entryId,
  ) : super.internal(
          (ref) => thumbnailById(
            ref,
            entryId,
          ),
          from: thumbnailByIdProvider,
          name: r'thumbnailByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$thumbnailByIdHash,
          dependencies: ThumbnailByIdFamily._dependencies,
          allTransitiveDependencies:
              ThumbnailByIdFamily._allTransitiveDependencies,
        );

  final String entryId;

  @override
  bool operator ==(Object other) {
    return other is ThumbnailByIdProvider && other.entryId == entryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entryId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
