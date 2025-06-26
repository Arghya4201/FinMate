import 'package:flutter/material.dart';
import 'package:finmate_frontend/features/auth/data/auth_api.dart';
import 'features/expenses/screens/expense_test_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinMate Auth Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: AuthTestPage(),
      home: ExpenseTestPage(),
    );
  }
}

class AuthTestPage extends StatefulWidget {
  @override
  _AuthTestPageState createState() => _AuthTestPageState();
}

class _AuthTestPageState extends State<AuthTestPage> {
  final AuthApi _authApi = AuthApi();

  void _testAuthFlow() async {
    try {
      // Step 1: Login
      final loginRes = await _authApi.login("john@example.com", "Arghya@08");
      print("✅ Logged in. Token: ${loginRes['access']}");

      // Step 2: Check if logged in
      final isLogged = await _authApi.isLoggedIn();
      print("🔐 Is Logged In: $isLogged");

      // Step 3: Fetch user profile
      await _authApi.fetchUserProfile();
    } catch (e) {
      print("❌ Error during auth flow: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Auth Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: _testAuthFlow,
          child: Text("Run Auth Flow"),
        ),
      ),
    );
  }
}
