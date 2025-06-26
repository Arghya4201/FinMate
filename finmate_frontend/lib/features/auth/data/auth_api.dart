import 'package:dio/dio.dart';
import '../../../core/constants/env.dart';

class AuthApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/'));

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post(
      'auth/login/', // Not full URL — base is already set
      data: {
        'email': email,
        'password': password,
      },
    );
    return res.data;
  }


  Future<Map<String, dynamic>> register(String email, String username, String password, String name) async {
    final res = await _dio.post('/auth/register/', data: {
      'email': email,
      'username': username,
      'password': password,
      'name': name,
    });
    return res.data;
  }
}

