import '../contracts/app_user.dart';
import '../contracts/auth_manager.dart';
import '../helpers/helpers.dart';

class Auth {
  Auth._();

  static AuthManager get manager => auth();

  static bool get check => auth().check;

  static AppUser? get user => auth().user;

  static String? get token => auth().token;

  static Future<bool> attempt(String username, String password) {
    return auth().attempt(username, password);
  }

  static Future<void> logout() {
    return auth().logout();
  }
}
