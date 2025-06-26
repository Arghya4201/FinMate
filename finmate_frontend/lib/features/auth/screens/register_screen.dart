import 'package:flutter/material.dart';
import 'package:finmate_frontend/features/auth/data/auth_api.dart';
import 'login_screen.dart';
import 'package:dio/dio.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthApi _authApi = AuthApi();

  void _register() async {
    try {
      await _authApi.register(
        _emailController.text,
        _usernameController.text,
        _passwordController.text,
        _nameController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Registered successfully. Please log in.")));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } catch (e) {
      String errorMessage = "❌ Registration failed";

      if (e is DioError) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          errorMessage = data.values.map((e) => e.toString()).join("\n");
        } else if (data is String) {
          errorMessage = data;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email")),
              TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: "Username")),
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Full Name")),
              TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password")),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _register, child: Text("Register")),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen())),
                child: Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
