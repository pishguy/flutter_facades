import '../contracts/app_config.dart';

class MapConfig implements AppConfig {
  const MapConfig(this.values);

  final Map<String, Object?> values;

  @override
  T get<T>(
    String key, {
    T? fallback,
  }) {
    if (!values.containsKey(key)) {
      if (fallback != null) {
        return fallback;
      }

      throw StateError('Config key "$key" was not found.');
    }

    final value = values[key];

    if (value is T) {
      return value;
    }

    throw StateError(
      'Config key "$key" is not of expected type $T. '
      'Actual value: $value',
    );
  }

  @override
  T? getOrNull<T>(String key) {
    if (!values.containsKey(key)) {
      return null;
    }

    final value = values[key];

    if (value is T) {
      return value;
    }

    return null;
  }

  @override
  bool has(String key) {
    return values.containsKey(key);
  }
}
