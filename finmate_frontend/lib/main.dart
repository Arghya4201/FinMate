import 'package:flutter/material.dart';
import 'package:finmate_frontend/features/auth/data/auth_api.dart';
import 'package:finmate_frontend/features/auth/screens/login_screen.dart';
import 'package:finmate_frontend/features/expenses/screens/dashboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthApi _authApi = AuthApi();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinMate',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: FutureBuilder<bool>(
        future: _authApi.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return snapshot.data == true ? DashboardPage() : LoginScreen();
        },
      ),
    );
  }
}
