import '../contracts/app_config.dart';
import '../helpers/helpers.dart';

class Config {
  Config._();

  static AppConfig get repository => config();

  static T get<T>(
    String key, {
    T? fallback,
  }) {
    return config().get<T>(key, fallback: fallback);
  }

  static T? getOrNull<T>(String key) {
    return config().getOrNull<T>(key);
  }

  static bool has(String key) {
    return config().has(key);
  }
}
