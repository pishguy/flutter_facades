import '../contracts/cache_store.dart';
import '../helpers/helpers.dart';

class Cache {
  Cache._();

  static CacheStore get store => cache();

  static Future<T?> get<T>(String key) {
    return cache().get<T>(key);
  }

  static Future<void> put<T>(
    String key,
    T value, {
    Duration? ttl,
  }) {
    return cache().put<T>(key, value, ttl: ttl);
  }

  static Future<void> forget(String key) {
    return cache().forget(key);
  }

  static Future<bool> has(String key) {
    return cache().has(key);
  }

  static Future<void> flush() {
    return cache().flush();
  }

  static Future<T> remember<T>(
    String key,
    Duration ttl,
    Future<T> Function() resolver,
  ) {
    return cache().remember<T>(key, ttl, resolver);
  }
}
