abstract interface class AppHttpClient {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  });

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  });

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  });
}
