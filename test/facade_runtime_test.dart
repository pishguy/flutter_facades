import 'package:test/test.dart';
import 'package:flutter_facades/flutter_facades.dart';

void main() {
  tearDown(() {
    FacadeRuntime.reset();
  });

  test('throws if resolver is not configured', () {
    expect(
      () => FacadeRuntime.resolve<CacheStore>(),
      throwsA(isA<ResolverNotConfiguredException>()),
    );
  });

  test('uses root resolver', () {
    final container = SimpleContainer();
    final cache = MemoryCacheStore();

    container.instance<CacheStore>(cache);

    FacadeRuntime.setRootResolver(container);

    expect(FacadeRuntime.resolve<CacheStore>(), same(cache));
  });

  test('scoped resolver overrides root resolver', () async {
    final root = SimpleContainer();
    final rootCache = MemoryCacheStore();
    root.instance<CacheStore>(rootCache);

    final scoped = SimpleContainer();
    final scopedCache = MemoryCacheStore();
    scoped.instance<CacheStore>(scopedCache);

    FacadeRuntime.setRootResolver(root);

    expect(FacadeRuntime.resolve<CacheStore>(), same(rootCache));

    await FacadeRuntime.runWithResolverAsync(scoped, () async {
      expect(FacadeRuntime.resolve<CacheStore>(), same(scopedCache));
    });

    expect(FacadeRuntime.resolve<CacheStore>(), same(rootCache));
  });
}
