abstract interface class AppConfig {
  T get<T>(
    String key, {
    T? fallback,
  });

  T? getOrNull<T>(String key);

  bool has(String key);
}
