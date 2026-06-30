import '../contracts/app_http_client.dart';
import '../helpers/helpers.dart';

class Http {
  Http._();

  static AppHttpClient get client => http();

  static Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return http().get(path, query: query, headers: headers);
  }

  static Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) {
    return http().post(path, data: data, headers: headers);
  }

  static Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) {
    return http().put(path, data: data, headers: headers);
  }

  static Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) {
    return http().delete(path, data: data, headers: headers);
  }
}
