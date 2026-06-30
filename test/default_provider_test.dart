import 'package:test/test.dart';
import 'package:flutter_facades/flutter_facades.dart';

void main() {
  test('default provider registers default services', () async {
    final container = SimpleContainer();

    final provider = DefaultFacadeServiceProvider(
      config: {
        'app.name': 'Provider Test',
      },
    );

    provider.register(container);
    await provider.boot(container);

    expect(container.resolve<AppConfig>(), isA<MapConfig>());
    expect(container.resolve<AppLogger>(), isA<ConsoleLogger>());
    expect(container.resolve<CacheStore>(), isA<MemoryCacheStore>());
    expect(container.resolve<AuthManager>(), isA<NullAuthManager>());
    expect(container.resolve<AppHttpClient>(), isA<ThrowingHttpClient>());
  });
}
