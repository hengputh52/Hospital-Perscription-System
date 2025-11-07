import 'dart:convert';
import 'dart:io';

class JsonStorageHelper {
  /// Read a JSON array from [path]. Returns an empty list if the file does
  /// not exist, is empty, malformed, or does not contain a JSON array.
  static List<dynamic> readJsonList(String path) {
    final file = File(path);
    if (!file.existsSync()) return <dynamic>[];
    try {
      final content = file.readAsStringSync();
      if (content.trim().isEmpty) return <dynamic>[];
      final decoded = jsonDecode(content);
      if (decoded is List) return decoded;
      // If file contains a single object, wrap it in a list for compatibility
      if (decoded is Map<String, dynamic>) return <dynamic>[decoded];
      return <dynamic>[];
    } catch (e, st) {
      stderr.writeln('JsonStorageHelper.readJsonList: failed to read $path -> $e\n$st');
      return <dynamic>[];
    }
  }

  /// Write a JSON array to [path]. Creates parent directories if needed.
  static void writeJsonList(String path, List<dynamic> data) {
    final file = File(path);
    try {
      if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
      final encoder = const JsonEncoder.withIndent('  ');
      file.writeAsStringSync(encoder.convert(data), flush: true);
    } catch (e, st) {
      stderr.writeln('JsonStorageHelper.writeJsonList: failed to write $path -> $e\n$st');
      rethrow;
    }
  }

  /// Append an object to the JSON array file (creates file if missing).
  static void appendJsonObject(String path, Map<String, dynamic> obj) {
    final list = readJsonList(path);
    list.add(obj);
    writeJsonList(path, list);
  }

  /// Update the first object in the JSON array where [idKey] == [idValue].
  /// Returns true if an object was found and updated.
  static bool updateJsonObjectById(String path, String idKey, String idValue, Map<String, dynamic> newObject) {
    final list = readJsonList(path);
    var changed = false;
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      if (item is Map<String, dynamic>) {
        final val = item[idKey];
        if (val != null && val.toString() == idValue) {
          list[i] = newObject;
          changed = true;
          break;
        }
      }
    }
    if (changed) writeJsonList(path, list);
    return changed;
  }

  /// Update objects matching [predicate]. [updater] receives the existing map
  /// and must return an updated map. Returns number of items updated.
  static int updateJsonObjectsWhere(String path, bool Function(Map<String, dynamic>) predicate,
      Map<String, dynamic> Function(Map<String, dynamic>) updater) {
    final list = readJsonList(path);
    var count = 0;
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      if (item is Map<String, dynamic> && predicate(item)) {
        list[i] = updater(Map<String, dynamic>.from(item));
        count++;
      }
    }
    if (count > 0) writeJsonList(path, list);
    return count;
  }
}

