import '../contracts/cache_store.dart';

class MemoryCacheStore implements CacheStore {
  final Map<String, _MemoryCacheEntry> _items = {};

  @override
  Future<T?> get<T>(String key) async {
    final entry = _items[key];

    if (entry == null) {
      return null;
    }

    if (entry.isExpired) {
      _items.remove(key);
      return null;
    }

    return entry.value as T?;
  }

  @override
  Future<void> put<T>(
    String key,
    T value, {
    Duration? ttl,
  }) async {
    _items[key] = _MemoryCacheEntry(
      value: value,
      expiresAt: ttl == null ? null : DateTime.now().add(ttl),
    );
  }

  @override
  Future<void> forget(String key) async {
    _items.remove(key);
  }

  @override
  Future<bool> has(String key) async {
    final entry = _items[key];

    if (entry == null) {
      return false;
    }

    if (entry.isExpired) {
      _items.remove(key);
      return false;
    }

    return true;
  }

  @override
  Future<void> flush() async {
    _items.clear();
  }

  @override
  Future<T> remember<T>(
    String key,
    Duration ttl,
    Future<T> Function() resolver,
  ) async {
    final cached = await get<T>(key);

    if (cached != null) {
      return cached;
    }

    final value = await resolver();
    await put<T>(key, value, ttl: ttl);

    return value;
  }
}

class _MemoryCacheEntry {
  _MemoryCacheEntry({
    required this.value,
    required this.expiresAt,
  });

  final Object? value;
  final DateTime? expiresAt;

  bool get isExpired {
    final expiresAt = this.expiresAt;

    if (expiresAt == null) {
      return false;
    }

    return DateTime.now().isAfter(expiresAt);
  }
}
