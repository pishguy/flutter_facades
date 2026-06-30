import '../contracts/app_http_client.dart';

class ThrowingHttpClient implements AppHttpClient {
  Never _notConfigured() {
    throw StateError(
      'AppHttpClient is not configured. '
      'Register your own AppHttpClient implementation in the container.',
    );
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    _notConfigured();
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    _notConfigured();
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    _notConfigured();
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    _notConfigured();
  }
}
