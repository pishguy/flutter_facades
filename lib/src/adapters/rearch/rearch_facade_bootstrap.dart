import '../../contracts/app_config.dart';
import '../../contracts/app_http_client.dart';
import '../../contracts/app_logger.dart';
import '../../contracts/auth_manager.dart';
import '../../contracts/cache_store.dart';
import '../../core/facade_runtime.dart';
import 'rearch_facade_resolver.dart';

class RearchFacadeBootstrap {
  RearchFacadeBootstrap._();

  static RearchFacadeResolver createResolver({
    required RearchServiceReader<CacheStore> cache,
    required RearchServiceReader<AuthManager> auth,
    required RearchServiceReader<AppHttpClient> http,
    required RearchServiceReader<AppLogger> logger,
    required RearchServiceReader<AppConfig> config,
  }) {
    final resolver = RearchFacadeResolver();

    resolver.register<CacheStore>(cache);
    resolver.register<AuthManager>(auth);
    resolver.register<AppHttpClient>(http);
    resolver.register<AppLogger>(logger);
    resolver.register<AppConfig>(config);

    return resolver;
  }

  static RearchFacadeResolver setAsRoot({
    required RearchServiceReader<CacheStore> cache,
    required RearchServiceReader<AuthManager> auth,
    required RearchServiceReader<AppHttpClient> http,
    required RearchServiceReader<AppLogger> logger,
    required RearchServiceReader<AppConfig> config,
  }) {
    final resolver = createResolver(
      cache: cache,
      auth: auth,
      http: http,
      logger: logger,
      config: config,
    );

    FacadeRuntime.setRootResolver(resolver);

    return resolver;
  }
}
