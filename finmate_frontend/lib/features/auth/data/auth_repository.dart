import 'auth_api.dart';

class AuthRepository {
  final AuthApi _api = AuthApi();

  Future<Map<String, dynamic>> login(String email, String password) {
    return _api.login(email, password);
  }

  Future<Map<String, dynamic>> register(String email, String username, String password, String name) {
    return _api.register(email, username, password, name);
  }
}
