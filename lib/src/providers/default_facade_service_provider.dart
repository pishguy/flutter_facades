import '../contracts/app_config.dart';
import '../contracts/app_http_client.dart';
import '../contracts/app_logger.dart';
import '../contracts/auth_manager.dart';
import '../contracts/cache_store.dart';
import '../core/service_provider.dart';
import '../core/simple_container.dart';
import '../implementations/console_logger.dart';
import '../implementations/map_config.dart';
import '../implementations/memory_cache_store.dart';
import '../implementations/null_auth_manager.dart';
import '../implementations/throwing_http_client.dart';

class DefaultFacadeServiceProvider extends ServiceProvider {
  DefaultFacadeServiceProvider({
    Map<String, Object?> config = const {},
  }) : _config = config;

  final Map<String, Object?> _config;

  @override
  void register(SimpleContainer container) {
    container.singleton<AppConfig>(
      (_) => MapConfig(_config),
    );

    container.singleton<AppLogger>(
      (_) => ConsoleLogger(),
    );

    container.singleton<CacheStore>(
      (_) => MemoryCacheStore(),
    );

    container.singleton<AuthManager>(
      (_) => NullAuthManager(),
    );

    container.singleton<AppHttpClient>(
      (_) => ThrowingHttpClient(),
    );
  }

  @override
  Future<void> boot(SimpleContainer container) async {
    container.resolve<AppLogger>().info('Facade services booted.');
  }
}
