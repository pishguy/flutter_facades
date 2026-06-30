import 'package:test/test.dart';
import 'package:flutter_facades/flutter_facades.dart';

void main() {
  setUp(() {
    final container = SimpleContainer();

    container.instance<AppConfig>(
      const MapConfig({
        'app.name': 'Test App',
        'api.base_url': 'https://example.com',
      }),
    );

    container.instance<CacheStore>(MemoryCacheStore());
    container.instance<AppLogger>(ConsoleLogger());
    container.instance<AuthManager>(NullAuthManager());
    container.instance<AppHttpClient>(ThrowingHttpClient());

    FacadeRuntime.setRootResolver(container);
  });

  tearDown(() {
    FacadeRuntime.reset();
  });

  test('Config facade reads config', () {
    expect(Config.get<String>('app.name'), 'Test App');
  });

  test('config helper reads same config', () {
    expect(config().get<String>('api.base_url'), 'https://example.com');
  });

  test('Config.getOrNull returns null for missing key', () {
    expect(Config.getOrNull<String>('missing'), isNull);
  });
}
