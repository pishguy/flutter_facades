import '../contracts/app_config.dart';
import '../contracts/app_http_client.dart';
import '../contracts/app_logger.dart';
import '../contracts/auth_manager.dart';
import '../contracts/cache_store.dart';
import '../core/facade_runtime.dart';

T app<T>() {
  return FacadeRuntime.resolve<T>();
}

CacheStore cache() {
  return app<CacheStore>();
}

AuthManager auth() {
  return app<AuthManager>();
}

AppHttpClient http() {
  return app<AppHttpClient>();
}

AppLogger logger() {
  return app<AppLogger>();
}

AppConfig config() {
  return app<AppConfig>();
}
