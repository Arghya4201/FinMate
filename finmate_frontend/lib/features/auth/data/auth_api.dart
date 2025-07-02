import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api/',
    headers: {'Content-Type': 'application/json'},
  ));

  AuthApi() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioError error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            print("🔐 Unauthorized (401) detected. Logging out...");
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('access_token');
            await prefs.remove('refresh_token');

            // Redirect to login
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  /// Save tokens to SharedPreferences
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
  Future<Map<String, dynamic>> register(
      String email, String username, String password, String name) async {
    final res = await _dio.post(
      'auth/register/',
      data: {
        'email': email,
        'username': username,
        'name': name,
        'password': password,
        'password2': password, // required by backend
      },
    );

    await _saveTokens(res.data['access'], res.data['refresh']);
    return res.data;
  }

  /// Fetch logged-in user's profile
  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      print("🚫 No access token found.");
      return;
    }

    final res = await _dio.get(
      'auth/user/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    print("👤 User Profile: ${res.data}");
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token != null;
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  /// Attach access token for authorized requests
  Future<Options> authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }
}
