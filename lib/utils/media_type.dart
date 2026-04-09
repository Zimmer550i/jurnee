import 'package:path/path.dart' as p;

const Set<String> _videoExtensions = {
  '.mp4',
  '.mov',
  '.mkv',
  '.avi',
  '.webm',
};

const Set<String> _imageExtensions = {
  '.jpg',
  '.jpeg',
  '.png',
  '.gif',
  '.webp',
};

bool isVideoMedia({required String path, String? mimeType}) {
  final normalizedMime = mimeType?.toLowerCase();
  if (normalizedMime?.startsWith('video/') ?? false) {
    return true;
  }
  if (normalizedMime?.startsWith('image/') ?? false) {
    return false;
  }

  final ext = p.extension(path).toLowerCase();
  if (_videoExtensions.contains(ext)) {
    return true;
  }
  if (_imageExtensions.contains(ext)) {
    return false;
  }

  // URL fallback when extension parsing is unreliable.
  final lowerPath = path.toLowerCase();
  return lowerPath.contains('.mp4') ||
      lowerPath.contains('.mov') ||
      lowerPath.contains('.mkv') ||
      lowerPath.contains('.avi') ||
      lowerPath.contains('.webm');
}

