import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api/',
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  /// Save access and refresh tokens
  Future<void> _saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  /// Login and store tokens
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post(
      'auth/login/',
      data: {
        'email': email,
        'password': password,
      },
    );

    await _saveTokens(res.data['access'], res.data['refresh']);
    return res.data;
  }

  /// Register and store tokens
  Future<Map<String, dynamic>> register(String email, String username, String password, String name) async {
    final res = await _dio.post(
      'auth/register/',
      data: {
        'email': email,
        'username': username,
        'password': password,
        'name': name,
      },
    );

    // Optionally save tokens after registration
    if (res.data.containsKey('access') && res.data.containsKey('refresh')) {
      await _saveTokens(res.data['access'], res.data['refresh']);
    }

    return res.data;
  }

  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      print("🚫 No access token found.");
      return;
    }

    final res = await _dio.get(
      'auth/user/', // Adjust if your endpoint differs
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    print("👤 User Profile: ${res.data}");
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}

