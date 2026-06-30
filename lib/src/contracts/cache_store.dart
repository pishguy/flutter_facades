abstract interface class CacheStore {
  Future<T?> get<T>(String key);

  Future<void> put<T>(
    String key,
    T value, {
    Duration? ttl,
  });

  Future<void> forget(String key);

  Future<bool> has(String key);

  Future<void> flush();

  Future<T> remember<T>(
    String key,
    Duration ttl,
    Future<T> Function() resolver,
  );
}
