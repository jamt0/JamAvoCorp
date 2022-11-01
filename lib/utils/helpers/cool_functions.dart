List<T> listFromJson<T>(
    dynamic json, T Function(Map<String, dynamic> data) mapper) {
  final List<T> items = [];
  json?.forEach((x) => items.add(mapper(x)));
  return items;
}
