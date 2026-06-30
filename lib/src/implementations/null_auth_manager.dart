import '../contracts/app_user.dart';
import '../contracts/auth_manager.dart';

class NullAuthManager implements AuthManager {
  @override
  bool get check => false;

  @override
  AppUser? get user => null;

  @override
  String? get token => null;

  @override
  Future<bool> attempt(String username, String password) async {
    return false;
  }

  @override
  Future<void> logout() async {}
}
