import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MaterialApp(home: LoginTestScreen()));
}

class LoginTestScreen extends StatelessWidget {
  const LoginTestScreen({super.key});

  Future<void> testLogin() async {
  final dio = Dio();

  try {
    final res = await dio.post(
      'http://10.0.2.2:8000/api/auth/login/',
      data: {
        "email": "john@example.com",
        "password": "Arghya@08"
      },
    );
    print("✅ Logged in, access token: ${res.data['access']}");
  } catch (e) {
    print("❌ Login error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: testLogin,
          child: const Text("Test Login API"),
        ),
      ),
    );
  }
}
