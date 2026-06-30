import 'package:test/test.dart';
import 'package:flutter_facades/flutter_facades.dart';

void main() {
  setUp(() {
    final container = SimpleContainer();

    container.instance<CacheStore>(MemoryCacheStore());
    container.instance<AppLogger>(ConsoleLogger());
    container.instance<AppConfig>(const MapConfig({}));
    container.instance<AuthManager>(NullAuthManager());
    container.instance<AppHttpClient>(ThrowingHttpClient());

    FacadeRuntime.setRootResolver(container);
  });

  tearDown(() {
    FacadeRuntime.reset();
  });

  test('Cache facade stores and retrieves value', () async {
    await Cache.put('x', 123);

    expect(await Cache.get<int>('x'), 123);
  });

  test('cache helper uses same store as Cache facade', () async {
    await Cache.put('name', 'Ali');

    expect(await cache().get<String>('name'), 'Ali');
  });

  test('remember caches resolved value', () async {
    var count = 0;

    final first = await Cache.remember<int>(
      'counter',
      const Duration(minutes: 1),
      () async {
        count++;
        return 10;
      },
    );

    final second = await Cache.remember<int>(
      'counter',
      const Duration(minutes: 1),
      () async {
        count++;
        return 20;
      },
    );

    expect(first, 10);
    expect(second, 10);
    expect(count, 1);
  });
}
