
///
class PathValue {
  PathValue({required this.path, required this.value});
  final String path;
  final dynamic value;
}

class DotMap {
  /// Returns a `PathValue` object used for the `create` method.
  PathValue pathValue(String path, dynamic value) => PathValue(path: path, value: value);

  /// Private method that takes a single `PathValue`
  /// object and returns a Map.
  Map<String, dynamic> _create(
    PathValue pathValue,
  ) {
    final keys = pathValue.path.split(".");
    var data = <String, dynamic>{};
    var subData = data;

    for (var key in keys.take(keys.length - 1)) {
      subData = subData[key] = <String, dynamic>{};
    }
    subData[keys.last] = pathValue.value;
    return data;
  }

  /// Gets the specified path's value.
  ///
  /// USAGE:
  /// ```dart
  /// DotMap.get(map, '1.2.3');
  /// ```
  T? get<T>(map, String path, {T Function(dynamic)? converter}) {
    List<String> keys = path.split('.');

    if (map[keys[0]] == null) {
      return null;
    }

    if (keys.length == 1) {
      return converter != null ? converter(map[keys[0]]) : map[keys[0]] as T;
    }

    return get(map[keys.removeAt(0)], keys.join('.'));
  }

  /// Sets the specified path's value.
  ///
  /// USAGE:
  /// ```dart
  /// DotMap.set(map, '1.2.3', '4');
  /// ```
  Map<String, dynamic> set(
    Map<String, dynamic> map,
    String path,
    dynamic value,
  ) {
    final keys = path.split(".");
    var subData = map;

    for (var key in keys.take(keys.length - 1)) {
      subData = subData[key] = <String, dynamic>{};
    }
    subData[keys.last] = value;
    return map;
  }

  /// A convinience method to merge a list of maps.
  ///
  /// USAGE:
  /// ```dart
  /// DotMap.merge([map1, map2]);
  /// ```
  merge(List<Map<String, dynamic>> maps) {
    final data = <String, dynamic>{};
    for (var map in maps) {
      data.addAll(map);
    }
    return data;
  }

  /// Can create a single or multi dimensional row(s) inside a `Map` by providing
  /// `PathValue` objects.
  ///
  /// USAGE:
  /// ```dart
  /// final map = DotMap.create([
  ///   PathValue(path: '1.2', value: {'3': 4}),
  ///   PathValue(path: '1.2', value: {'3': 4}),
  /// ]);
  /// ```
  create(
    List<PathValue> pathValues,
  ) {
    var list = <Map<String, dynamic>>[];
    for (var pathValue in pathValues) {
      list.add(_create(pathValue));
    }
    return merge(list);
  }
}
