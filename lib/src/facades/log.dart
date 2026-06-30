import '../contracts/app_logger.dart';
import '../helpers/helpers.dart';

class Log {
  Log._();

  static AppLogger get channel => logger();

  static void debug(
    String message, {
    Map<String, Object?> context = const {},
  }) {
    logger().debug(message, context: context);
  }

  static void info(
    String message, {
    Map<String, Object?> context = const {},
  }) {
    logger().info(message, context: context);
  }

  static void warning(
    String message, {
    Map<String, Object?> context = const {},
  }) {
    logger().warning(message, context: context);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    logger().error(
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }
}
