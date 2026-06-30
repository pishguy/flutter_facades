import 'app_user.dart';

abstract interface class AuthManager {
  bool get check;

  AppUser? get user;

  String? get token;

  Future<bool> attempt(String username, String password);

  Future<void> logout();
}
