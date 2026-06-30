import '../contracts/app_logger.dart';

class ConsoleLogger implements AppLogger {
  @override
  void debug(
    String message, {
    Map<String, Object?> context = const {},
  }) {
    print('[DEBUG] $message${_formatContext(context)}');
  }

  @override
  void info(
    String message, {
    Map<String, Object?> context = const {},
  }) {
    print('[INFO] $message${_formatContext(context)}');
  }

  @override
  void warning(
    String message, {
    Map<String, Object?> context = const {},
  }) {
    print('[WARNING] $message${_formatContext(context)}');
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    print('[ERROR] $message${_formatContext(context)}');

    if (error != null) {
      print('[ERROR_OBJECT] $error');
    }

    if (stackTrace != null) {
      print('[STACK_TRACE] $stackTrace');
    }
  }

  String _formatContext(Map<String, Object?> context) {
    if (context.isEmpty) {
      return '';
    }

    return ' | context=$context';
  }
}
