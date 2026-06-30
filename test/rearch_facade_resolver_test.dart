import 'package:test/test.dart';
import 'package:flutter_facades/flutter_facades.dart';

void main() {
  test('resolves registered reader', () {
    final resolver = RearchFacadeResolver();

    final cache = MemoryCacheStore();

    resolver.register<CacheStore>(() => cache);

    expect(resolver.resolve<CacheStore>(), same(cache));
  });

  test('contains returns true if reader is registered', () {
    final resolver = RearchFacadeResolver();

    resolver.register<CacheStore>(() => MemoryCacheStore());

    expect(resolver.contains<CacheStore>(), isTrue);
  });

  test('throws when reader is missing', () {
    final resolver = RearchFacadeResolver();

    expect(
      () => resolver.resolve<CacheStore>(),
      throwsA(isA<BindingNotFoundException>()),
    );
  });

  test('can be used as FacadeRuntime root resolver', () async {
    final resolver = RearchFacadeResolver();

    final cacheStore = MemoryCacheStore();

    resolver.register<CacheStore>(() => cacheStore);
    resolver.register<AppLogger>(() => ConsoleLogger());
    resolver.register<AppConfig>(() => const MapConfig({}));
    resolver.register<AuthManager>(() => NullAuthManager());
    resolver.register<AppHttpClient>(() => ThrowingHttpClient());

    FacadeRuntime.setRootResolver(resolver);

    await Cache.put('x', 1);

    expect(await Cache.get<int>('x'), 1);

    FacadeRuntime.reset();
  });
}
