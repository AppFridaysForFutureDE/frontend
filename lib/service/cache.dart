import 'dart:io';

class CacheService {
  Directory cacheDirectory;

  CacheService(this.cacheDirectory);

  File fileFromPath(String path) => File('${cacheDirectory.path}/$path');

  bool exists(String path) {
    return fileFromPath(path).existsSync();
  }

  put(String path, String content) {
    fileFromPath(path)
        .create(recursive: true)
        .then((_) => fileFromPath(path).writeAsString(content));
  }

  String get(String path) {
    return fileFromPath(path).readAsStringSync();
  }
}
